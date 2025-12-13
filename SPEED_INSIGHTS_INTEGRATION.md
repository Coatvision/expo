# Vercel Speed Insights Integration Guide

This document describes how Vercel Speed Insights has been integrated into the Expo project.

## Overview

Vercel Speed Insights is a performance monitoring tool that automatically captures and reports on Core Web Vitals and other performance metrics from your users' browsers. It works only in production and on web platforms.

## Installation

The `@vercel/speed-insights` package is included as a dependency in the main `expo` package. No additional installation is needed when you install `expo`.

## What's New

### New Module: `expo/speed-insights`

A new module has been created to provide easy access to Speed Insights functionality:

**Location**: `packages/expo/src/speed-insights/`

**Exports**:
- `injectSpeedInsights()` - Function to inject the Speed Insights tracking script
- `computeRoute()` - Utility function for computing route names
- `SpeedInsightsProps` - TypeScript type for configuration
- `BeforeSendMiddleware` - TypeScript type for middleware functions

## Integration Patterns

### Pattern 1: React Component (Recommended for React Apps)

```tsx
'use client'; // For Next.js App Router

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

### Pattern 2: Function-Based Injection

For vanilla JavaScript or non-React applications:

```js
import { injectSpeedInsights } from 'expo/speed-insights';

// Call once during app initialization
injectSpeedInsights({
  debug: false,
  sampleRate: 1.0,
});
```

### Pattern 3: Static HTML Sites

For plain HTML without npm, add the script tag directly to your HTML:

```html
<script defer src="https://cdn.vercel-insights.com/v1/script.js"></script>
```

## Configuration Options

Both the React component and `injectSpeedInsights()` function accept these options:

```typescript
interface SpeedInsightsProps {
  // Sample rate: 0-1, determines what percentage of users are tracked
  // Default: 1 (100% of users)
  sampleRate?: number;

  // Whether to enable debug logging in development
  // Default: true
  debug?: boolean;

  // The dynamic route name (useful for grouped metrics)
  // Example: "/products/[id]"
  route?: string;

  // Function to modify or filter events before sending
  // Return null to skip sending an event
  beforeSend?: (event: any) => any | null;

  // Custom endpoint for self-hosted Speed Insights
  endpoint?: string;

  // The DSN (Data Source Name) of your project
  // Only needed when self-hosting
  dsn?: string;
}
```

## Example Implementations

### Next.js App

```tsx
// app/layout.tsx
'use client';

import { SpeedInsights } from '@vercel/speed-insights/react';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        {children}
        <SpeedInsights />
      </body>
    </html>
  );
}
```

### React Application

```tsx
// App.tsx
import { useEffect } from 'react';
import { injectSpeedInsights } from 'expo/speed-insights';

function App() {
  useEffect(() => {
    injectSpeedInsights({
      debug: true,
      beforeSend: (event) => {
        // Example: Filter out certain events
        if (event.type === 'web-vital') {
          return event;
        }
        return null;
      },
    });
  }, []);

  return <div>My App</div>;
}

export default App;
```

### Expo Router Web

```tsx
// app/_layout.tsx
import { Stack } from 'expo-router';
import { useEffect } from 'react';
import { injectSpeedInsights } from 'expo/speed-insights';

export default function RootLayout() {
  useEffect(() => {
    // Only inject on web platform
    if (typeof window !== 'undefined') {
      injectSpeedInsights();
    }
  }, []);

  return <Stack />;
}
```

## Platform Considerations

### Web Platforms
Speed Insights works seamlessly on web platforms (Next.js, React, Expo Router web, etc.)

### Native Platforms
Speed Insights is web-only and will not work on:
- React Native (native Android/iOS)
- Expo Go
- Native builds

**Best Practice**: Use platform-specific imports or conditional checks:

```tsx
import { Platform } from 'react-native';

useEffect(() => {
  if (Platform.OS === 'web') {
    injectSpeedInsights();
  }
}, []);
```

## Important Notes

### Development Mode
Speed Insights does **not** track data in development mode. Tracking is only active in production builds.

### Client-Side Only
Speed Insights must run on the client side. In Next.js, use:
```tsx
'use client'; // Mark as client component
```

### Vercel Project Required
You must:
1. Deploy to Vercel
2. Enable Speed Insights in the Vercel Dashboard for your project
3. Then data will start appearing

## Vercel Dashboard Setup

1. Go to your project in the [Vercel Dashboard](https://vercel.com)
2. Navigate to Settings → Speed Insights
3. Enable Speed Insights
4. Deploy a new build
5. Wait for user traffic to collect metrics

## Documentation & Resources

- **Official Docs**: https://vercel.com/docs/speed-insights
- **Package Documentation**: https://vercel.com/docs/speed-insights/package
- **GitHub Repository**: https://github.com/vercel/speed-insights

## Framework-Specific Integration

The `@vercel/speed-insights` package includes optimized integrations for:

- **Next.js**: `@vercel/speed-insights/next`
- **React**: `@vercel/speed-insights/react`
- **Nuxt**: `@vercel/speed-insights/nuxt`
- **Vue**: `@vercel/speed-insights/vue`
- **Remix**: `@vercel/speed-insights/remix`
- **SvelteKit**: `@vercel/speed-insights/sveltekit`
- **Astro**: `@vercel/speed-insights/astro`

For framework-specific guidance, refer to the [official documentation](https://vercel.com/docs/speed-insights/quickstart).

## Metrics Collected

Speed Insights automatically collects:

- **Core Web Vitals**
  - Largest Contentful Paint (LCP)
  - First Input Delay (FID) / Interaction to Next Paint (INP)
  - Cumulative Layout Shift (CLS)

- **Web Vitals**
  - First Paint (FP)
  - First Contentful Paint (FCP)
  - Time to First Byte (TTFB)

- **Custom Events**
  - Page load timing
  - Navigation timing
  - Resource timing
  - User interactions

## Troubleshooting

### Script Not Loading
If the Speed Insights script fails to load, check:
1. Content blockers or security extensions
2. Network issues or CDN availability
3. Browser console for error messages

### No Data Appearing
Ensure:
1. Speed Insights is enabled in Vercel Dashboard
2. You're viewing production data (not development)
3. The app is deployed to Vercel
4. Users have visited the site after enabling

### Performance Impact
Speed Insights has minimal performance impact:
- Loads asynchronously (non-blocking)
- Gzip'd script is ~4KB
- Uses `requestIdleCallback` for non-critical operations

## License

@vercel/speed-insights is licensed under the Apache License 2.0.
Expo is licensed under the MIT License.
