const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const Anthropic = require("@anthropic-ai/sdk");

setGlobalOptions({maxInstances: 10});

const anthropicApiKey = defineSecret("ANTHROPIC_API_KEY");

const SYSTEM_PROMPTS = {
  buyer:
    "You are an enthusiastic art collector and investor evaluating" +
    " a potential acquisition. You see everything through the lens" +
    " of investment value, provenance, and collectability. You ask" +
    " about the artist's background, edition size, and how this" +
    " piece fits into the current market. You genuinely want to" +
    " own this work and aren't shy about it." +
    " Keep your critique to 3-4 sentences.",

  admirer:
    "You are someone with a deep, genuine love of art who is moved" +
    " by this piece on an emotional and aesthetic level. You aren't" +
    " in the market to buy and you can't afford it anyway, but that" +
    " doesn't diminish your appreciation. You notice the craft, the" +
    " feeling, the visual language the artist is using. You speak" +
    " from the heart. Keep your critique to 3-4 sentences.",

  skeptic:
    "You are a dismissive critic who questions the value of" +
    " contemporary and abstract art. Your default reaction is" +
    " \"my 5th grader could do that.\" You challenge whether this" +
    " qualifies as real skill, whether the emperor has any clothes," +
    " and what exactly justifies calling this art. You're not" +
    " cruel, just deeply unimpressed." +
    " Keep your critique to 3-4 sentences.",
};

const VALID_PERSONAS = Object.keys(SYSTEM_PROMPTS);

/**
 * Detects the MIME type from a base64-encoded image string.
 * @param {string} base64 - The base64-encoded image data.
 * @return {string} The detected MIME type.
 */
function detectMimeType(base64) {
  if (base64.startsWith("iVBORw0K")) return "image/png";
  if (base64.startsWith("R0lGOD")) return "image/gif";
  if (base64.startsWith("UklGR")) return "image/webp";
  return "image/jpeg";
}

exports.critique = onRequest(
    {secrets: [anthropicApiKey], cors: true},
    async (req, res) => {
      if (req.method !== "POST") {
        res.status(405).json({error: "Method not allowed"});
        return;
      }

      const {imageBase64, personaId} = req.body;

      if (!imageBase64 || !personaId) {
        res.status(400).json({error: "imageBase64 and personaId are required"});
        return;
      }

      if (!VALID_PERSONAS.includes(personaId)) {
        res.status(400).json({
          error: `personaId must be one of: ${VALID_PERSONAS.join(", ")}`,
        });
        return;
      }

      try {
        const client = new Anthropic({apiKey: anthropicApiKey.value()});

        const message = await client.messages.create({
          model: "claude-haiku-4-5-20251001",
          max_tokens: 500,
          system: SYSTEM_PROMPTS[personaId],
          messages: [
            {
              role: "user",
              content: [
                {
                  type: "image",
                  source: {
                    type: "base64",
                    media_type: detectMimeType(imageBase64),
                    data: imageBase64,
                  },
                },
                {
                  type: "text",
                  text: "Please critique this artwork.",
                },
              ],
            },
          ],
        });

        const critique = message.content[0].text;
        logger.info("Critique generated", {personaId});
        res.status(200).json({critique});
      } catch (error) {
        logger.error("Claude API error", {error: error.message});
        res.status(500).json({error: "Failed to generate critique"});
      }
    },
);
