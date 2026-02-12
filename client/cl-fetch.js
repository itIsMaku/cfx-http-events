async function sendEvent(
	endpoint,
	resourceName,
	eventName,
	auth,
	args,
	requestId,
) {
	try {
		const response = await fetch(
			`http://${endpoint}/${resourceName}/event/${eventName}`,
			{
				method: "post",
				headers: {
					"Content-Type": "application/json; charset=UTF-8",
					Authorization: auth,
					"Request-Id": requestId,
				},
				body: args,
				cache: "no-cache",
			},
		);

		if (!response.ok) {
			console.error(
				`Failed to send event: ${response.status} ${response.statusText}`,
			);
			return;
		}

		const responseData = await response.json();
		await fetch(`https://${resourceName}/${requestId}`, {
			method: "post",
			headers: {
				"Content-Type": "application/json; charset=UTF-8",
			},
			body: JSON.stringify(responseData),
		});
	} catch (error) {
		console.error("Error sending event:", error);
	}
}

window.addEventListener("message", (event) => {
	if (event.data && event.data.type === "sendEvent") {
		const { endpoint, resourceName, eventName, auth, args, requestId } =
			event.data.data;
		sendEvent(endpoint, resourceName, eventName, auth, args, requestId);
	}
});
