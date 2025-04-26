'use server';
/**
 * @fileOverview Implements a payment processing AI agent.
 *
 * - processPayment - A function that handles the payment processing.
 * - PaymentInfo - The input type for the processPayment function.
 * - PaymentResult - The return type for the processPayment function.
 */

import {ai} from '@/ai/ai-instance';
import {z} from 'genkit';

const PaymentInfoSchema = z.object({
  cardNumber: z.string().describe('The credit card number.'),
  expiryDate: z.string().describe('The expiry date of the credit card.'),
  cvv: z.string().describe('The CVV code of the credit card.'),
  amount: z.number().describe('The amount to be paid.'),
});

export type PaymentInfo = z.infer<typeof PaymentInfoSchema>;

const PaymentResultSchema = z.object({
  success: z.boolean().describe('Whether the payment was successful.'),
  message: z.string().describe('A message providing details about the payment result.'),
});

export type PaymentResult = z.infer<typeof PaymentResultSchema>;

export async function processPayment(paymentInfo: PaymentInfo): Promise<PaymentResult> {
  return processPaymentFlow(paymentInfo);
}

const prompt = ai.definePrompt({
  name: 'processPaymentPrompt',
  input: {
    schema: z.object({
      cardNumber: z.string().describe('The credit card number.'),
      expiryDate: z.string().describe('The expiry date of the credit card.'),
      cvv: z.string().describe('The CVV code of the credit card.'),
      amount: z.number().describe('The amount to be paid.'),
    }),
  },
  output: {
    schema: z.object({
      success: z.boolean().describe('Whether the payment was successful.'),
      message: z.string().describe('A message providing details about the payment result.'),
    }),
  },
  prompt: `You are an expert payment processor.

You will take the payment information provided and process the payment. You will then return a success or failure message.

Card Number: {{{cardNumber}}}
Expiry Date: {{{expiryDate}}}
CVV: {{{cvv}}}
Amount: {{{amount}}}`,
});

const processPaymentFlow = ai.defineFlow<typeof PaymentInfoSchema, typeof PaymentResultSchema>(
  {
    name: 'processPaymentFlow',
    inputSchema: PaymentInfoSchema,
    outputSchema: PaymentResultSchema,
  },
  async input => {
    const {output} = await prompt(input);
    return output!;
  }
);
