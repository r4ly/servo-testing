export const dynamic = "force-dynamic";

type AngleState = { angle: number; rawAngle: number; updatedAt: number };
const state = globalThis as typeof globalThis & { servoAngleState?: AngleState };

export async function GET() {
  return Response.json(state.servoAngleState ?? { angle: 0, rawAngle: 0, updatedAt: 0 }, {
    headers: { "Cache-Control": "no-store" },
  });
}

export async function POST(request: Request) {
  const payload = await request.json() as Partial<AngleState>;
  if (!Number.isFinite(payload.angle) || !Number.isFinite(payload.rawAngle)) {
    return Response.json({ error: "angle and rawAngle must be numbers" }, { status: 400 });
  }
  state.servoAngleState = {
    angle: Math.min(180, Math.max(0, Number(payload.angle))),
    rawAngle: Number(payload.rawAngle),
    updatedAt: Date.now(),
  };
  return Response.json(state.servoAngleState);
}
