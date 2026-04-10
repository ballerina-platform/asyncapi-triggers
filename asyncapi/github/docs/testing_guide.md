# User Guide: End-to-End Testing with GitHub Webhook Integration

This guide provides step-by-step instructions to test the Ballerina GitHub Trigger connector end-to-end using an actual GitHub repository.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) installed (Swan Lake 2201.11.0 or later).
- A [GitHub account](https://github.com/) and a repository to test with.
- [ngrok](https://ngrok.com/) or a similar tool to expose your local server to the internet.

---

## Step 1: Set up a Public Endpoint

GitHub needs a public URL to send webhook payloads. Since your Ballerina service runs locally, you can use ngrok to create a secure tunnel.

1.  Run your Ballerina service on a specific port (e.g., `8090`).
2.  Open a terminal and start ngrok:
    ```bash
    ngrok http 8090
    ```
3.  Copy the `Forwarding` URL (e.g., `https://random-id.ngrok-free.app`). This will be your **Payload URL**.

---

## Step 2: Create a GitHub Webhook

1.  Navigate to your GitHub repository.
2.  Click on **Settings** > **Webhooks** > **Add webhook**.
3.  **Payload URL**: Paste the ngrok URL (ensure it ends with a `/`, e.g., `https://random-id.ngrok-free.app/`).
4.  **Content type**: Select `application/json`.
5.  **Secret**: (Optional but recommended) Provide a secret string (e.g., `my-webhook-secret`).
6.  **Which events would you like to trigger this webhook?**:
    - Select **Let me select individual events**.
    - Check the events you want to test (e.g., `Issues`, `Issue comments`, `Pushes`).
7.  Ensure **Active** is checked.
8.  Click **Add webhook**.

---

## Step 3: Implement the Ballerina GitHub Trigger

Create a new Ballerina file (e.g., `main.bal`) and implement the services for the events you selected.

```ballerina
import ballerina/log;
import ballerinax/trigger.github;

// Configure the listener with the secret you set in GitHub
configurable github:ListenerConfig config = {
    webhookSecret: "my-webhook-secret" 
};

// Initialize the listener on port 8090
listener github:Listener githubListener = new (config, 8090);

// Implement the service for Issue events
service github:IssuesService on githubListener {
    remote function onOpened(github:IssuesEvent payload) returns error? {
        log:printInfo("Issue Opened: " + payload.issue.title);
        log:printInfo("Issue URL: " + payload.issue.html_url);
    }

    remote function onClosed(github:IssuesEvent payload) returns error? {
        log:printInfo("Issue Closed: " + payload.issue.title);
    }
}

// Implement the service for Issue Comment events
service github:IssueCommentService on githubListener {
    remote function onCreated(github:IssueCommentEvent payload) returns error? {
        log:printInfo("New Comment by " + payload.comment.user.login);
        log:printInfo("Comment: " + payload.comment.body);
    }
}
```

---

## Step 4: Run the Ballerina Service

1.  Open a terminal in the directory containing `main.bal`.
2.  Run the service:
    ```bash
    bal run
    ```
    You should see the service starting up and listening on port `8090`.

---

## Step 5: Trigger Events and Verify

Go to your GitHub repository and perform the actions corresponding to the events you subscribed to. Below are the steps to trigger major event types:

### 1. Issues
- **Opened**: Go to **Issues** > **New issue**, enter a title/body, and click **Submit new issue**.
- **Closed**: Open an existing issue and click **Close issue**.
- **Assigned**: Open an issue, and in the right sidebar, click **Assignees** to assign yourself or someone else.
- **Labeled**: Open an issue, and in the right sidebar, click **Labels** to add or remove a label.

### 2. Issue Comments
- **Created**: Open an existing issue or pull request and post a new comment.
- **Edited**: Click the `...` menu on your comment and select **Edit**.
- **Deleted**: Click the `...` menu on your comment and select **Delete**.

### 3. Pull Requests
- **Opened**: Create a new branch, make a change, push it, and then click **Compare & pull request** on GitHub.
- **Closed**: Open a pull request and click **Close pull request** (or merge it).
- **Review Requested**: In a pull request, click **Reviewers** in the right sidebar to request a review.

### 4. Pushes
- **Push**: Commit a change locally and push it to the repository:
  ```bash
  git add .
  git commit -m "Testing push event"
  git push origin main
  ```

### 5. Releases
- **Published**: Go to **Releases** > **Create a new release**, enter a tag version and title, and click **Publish release**.

### 6. Labels & Milestones
- **Label Created**: Go to **Issues** > **Labels** > **New label**.
- **Milestone Created**: Go to **Issues** > **Milestones** > **New milestone**.

## Step 6: Verify the Results

Check your Ballerina service logs. You should see the output from your remote functions confirming the receipt of the events:
```
time=2026-04-10T17:00:00.000 level=INFO message="Issue Opened: My Test Issue"
time=2026-04-10T17:00:05.000 level=INFO message="New Comment by octocat"
time=2026-04-10T17:00:10.000 level=INFO message="Received push-event-message"
```

---

## Troubleshooting

- **Check ngrok Status**: Ensure ngrok is running and forwarding requests to the correct port.
- **Inspect Webhook Deliveries**:
    - In GitHub, go to **Settings** > **Webhooks**.
    - Click **Edit** on your webhook.
    - Scroll down to **Recent Deliveries**.
    - You can see the request headers, payload, and the response from your Ballerina service. Green checkmarks indicate successful delivery (HTTP 200).
- **Trailing Slash**: Ensure the **Payload URL** in GitHub ends with a `/`.
- **Secret Mismatch**: If you provided a secret, ensure it matches the `webhookSecret` in your `github:ListenerConfig`. If they don't match, the trigger will log a "Signature verification failure".
- **Firewall/Proxy**: If you are behind a corporate firewall, ensure ngrok is allowed or configure the Ballerina listener to work with your proxy settings.

---
