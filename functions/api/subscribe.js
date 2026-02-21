const AUDIENCE_MAP = {
  "agent-stack": "RESEND_AUDIENCE_ID",
  "daily-briefing": "RESEND_AUDIENCE_DAILY_ID",
};

const VALID_NEWSLETTERS = new Set(Object.keys(AUDIENCE_MAP));

export async function onRequestPost({ request, env }) {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
  };

  const json = (body, status = 200) =>
    new Response(JSON.stringify(body), {
      status,
      headers: { "Content-Type": "application/json", ...corsHeaders },
    });

  try {
    const { email, newsletters } = await request.json();

    if (!email || !email.includes("@")) {
      return json({ error: "Valid email required" }, 400);
    }

    // Support legacy single-newsletter requests (no newsletters field)
    const selected = Array.isArray(newsletters)
      ? newsletters.filter((n) => VALID_NEWSLETTERS.has(n))
      : ["agent-stack"];

    if (selected.length === 0) {
      return json({ error: "Select at least one newsletter" }, 400);
    }

    // Subscribe to each selected audience in parallel
    const results = await Promise.allSettled(
      selected.map(async (nl) => {
        const audienceId = env[AUDIENCE_MAP[nl]];
        if (!audienceId) {
          throw new Error(`Audience not configured for ${nl}`);
        }

        const res = await fetch(
          `https://api.resend.com/audiences/${audienceId}/contacts`,
          {
            method: "POST",
            headers: {
              Authorization: `Bearer ${env.RESEND_API_KEY}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ email, unsubscribed: false }),
          }
        );

        if (!res.ok) {
          const err = await res.json();
          throw new Error(err.message || `Failed to subscribe to ${nl}`);
        }

        return nl;
      })
    );

    const succeeded = results
      .filter((r) => r.status === "fulfilled")
      .map((r) => r.value);
    const failed = results
      .filter((r) => r.status === "rejected")
      .map((r) => r.reason.message);

    if (succeeded.length === 0) {
      return json({ error: failed[0] || "Failed to subscribe" }, 500);
    }

    return json({ success: true, subscribed: succeeded });
  } catch (e) {
    return json({ error: "Something went wrong" }, 500);
  }
}

export async function onRequestOptions() {
  return new Response(null, {
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    },
  });
}
