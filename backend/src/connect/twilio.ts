const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const service = process.env.TWILIO_SERVICE;
import twilio from "twilio";
const client = twilio(accountSid, authToken);

export async function createVerification(email: string): Promise<Boolean> {
  console.log(email);
  return await client.verify
    .services(service)
    .verifications.create({ to: email, channel: "email" })
    .then((res) => {
      return true;
    })
    .catch(() => false);
}
export async function checkVerification(
  email: string,
  code: string
): Promise<Boolean> {
  return await client.verify
    .services(service)
    .verificationChecks.create({ to: email, code: code })
    .then((verification_check) => verification_check["valid"])
    .catch(() => false); //TODO delete user?
}
