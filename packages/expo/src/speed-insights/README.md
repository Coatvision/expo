# Vercel Speed Insights Integration

Vercel Speed Insights is a tool that automatically tracks and reports on web performance metrics like Core Web Vitals from your users' browsers. This module provides easy integration with Expo applications.

## Installation

@vercel/speed-insights is already included as a dependency when you install `expo`.

## Quick Start

### For React/Next.js Web Apps

The recommended approach is to use the `SpeedInsights` React component:

```tsx
import { SpeedInsights } from '@vercel/speed-insights/react';

export default function App() {
  return (
    <>
      <SpeedInsights />
      {/* Rest of your app */}
    </>
  );
}
```

### For Vanilla JavaScript or Other Frameworks

Use the `injectSpeedInsights()` function from the `expo/speed-insights` module:

```ts
import { injectSpeedInsights } from 'expo/speed-insights';

// Call this once in your app initialization
injectSpeedInsights();
```

## Configuration

Both the React component and the `injectSpeedInsights` function accept configuration options:

```tsx
import { injectSpeedInsights } from 'expo/speed-insights';

injectSpeedInsights({
  // Sample rate: 0-1, defaults to 1 (100%)
  sampleRate: 0.5,
  
  // Debug logging in development
  debug: true,
  
  // Route name for aggregating metrics across similar pages
  route: '/products/[id]',
  
  // Custom middleware to modify events before sending
  beforeSend: (event) => {
    // Filter out sensitive data, etc.
    return event;
  },
  
  // Custom endpoint for self-hosted Speed Insights
  endpoint: 'https://your-server.com/speed-insights',
});
```

For React component configuration:

```tsx
import { SpeedInsights } from '@vercel/speed-insights/react';

<SpeedInsights 
  sampleRate={0.5}
  debug={true}
  route="/products/[id]"
/>
```

## Important Notes

- **Client-side only**: Speed Insights must be called on the client side. Use `'use client'` in Next.js App Router or ensure the code runs in the browser.
- **Production only**: Speed Insights does not track data in development mode.
- **Requires Vercel**: You need to enable Speed Insights in your Vercel project dashboard to see data.
- **No installation required for static sites**: If you're using plain HTML without npm, add the script tag directly to your `<head>`:

```html
<script defer src="https://cdn.vercel-insights.com/v1/script.js"></script>
```

## Available Exports

From `expo/speed-insights`:

- `injectSpeedInsights()` - Function to inject Speed Insights script
- `computeRoute()` - Utility function for computing route names
- `SpeedInsightsProps` - TypeScript type for configuration props
- `BeforeSendMiddleware` - TypeScript type for beforeSend middleware

## Framework-Specific Imports

The @vercel/speed-insights package also provides framework-specific exports:

- `@vercel/speed-insights/react` - React component and utilities
- `@vercel/speed-insights/next` - Next.js specific integration
- `@vercel/speed-insights/nuxt` - Nuxt integration
- `@vercel/speed-insights/sveltekit` - SvelteKit integration
- `@vercel/speed-insights/vue` - Vue integration
- `@vercel/speed-insights/astro` - Astro component
- `@vercel/speed-insights/remix` - Remix integration

## Documentation

For more information and advanced usage, visit:
https://vercel.com/docs/speed-insights
