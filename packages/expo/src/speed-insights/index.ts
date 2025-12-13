/**
 * Vercel Speed Insights integration for Expo
 *
 * This module provides client-side integration with Vercel Speed Insights.
 * Speed Insights automatically tracks web vitals and performance metrics.
 *
 * Usage in React/Web apps:
 * ```tsx
 * import { SpeedInsights } from '@vercel/speed-insights/react';
 * import { injectSpeedInsights } from 'expo/speed-insights';
 *
 * // Method 1: Using React component (recommended for React apps)
 * export default function App() {
 *   return (
 *     <>
 *       <SpeedInsights />
 *       {/* rest of your app */}
 *     </>
 *   );
 * }
 *
 * // Method 2: Using injectSpeedInsights function
 * useEffect(() => {
 *   injectSpeedInsights();
 * }, []);
 * ```
 *
 * For vanilla JS or other frameworks, use the injectSpeedInsights function:
 * ```ts
 * import { injectSpeedInsights } from 'expo/speed-insights';
 *
 * injectSpeedInsights();
 * ```
 *
 * Note: Speed Insights only tracks data in production. Development mode is skipped.
 * Refer to Vercel's documentation for more details: https://vercel.com/docs/speed-insights
 */

// Re-export the core function from @vercel/speed-insights for web environments
export { injectSpeedInsights, computeRoute } from '@vercel/speed-insights';
export type { SpeedInsightsProps, BeforeSendMiddleware } from '@vercel/speed-insights';
