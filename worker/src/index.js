export default {
    async fetch(request, env) {

        const url =
            new URL(request.url);

        // Health check
        if (url.pathname === "/") {

            return new Response(
                "Trendify Worker OK",
                {
                    status: 200
                }
            );
        }

        // Only /vless
        if (url.pathname !== "/vless") {

            return new Response(
                "Not Found",
                {
                    status: 404
                }
            );
        }

        // Must be WebSocket
        const upgrade =
            request.headers.get("Upgrade");

        if (
            !upgrade ||
            upgrade.toLowerCase() !== "websocket"
        ) {

            return new Response(
                "Expected WebSocket",
                {
                    status: 426,
                    headers: {
                        "Upgrade": "websocket"
                    }
                }
            );
        }

        if (!env.RAILWAY_URL) {

            return new Response(
                "RAILWAY_URL is not configured",
                {
                    status: 500
                }
            );
        }

        const target =
            new URL(env.RAILWAY_URL);

        target.pathname = "/vless";
        target.search = url.search;

        const headers =
            new Headers(
                request.headers
            );

        headers.set(
            "Host",
            target.host
        );

        const response =
            await fetch(
                target.toString(),
                {
                    method: "GET",
                    headers
                }
            );

        return response;
    }
};
