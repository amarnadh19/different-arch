# Serverless project

![](https://miro.medium.com/v2/resize:fit:875/1*9nOY1w2hZtUazedMC7a-Ew.png)

## Variant A — AWS Batch (Best for Burst Workloads)

When you need to submit thousands of jobs at once, AWS Batch Array Jobs are your friend. A Lambda function receives the S3 event, builds a list of objects, and submits a single array job with one Batch task per object. Batch manages retries, scheduling, and concurrency for you.

**The catch:** Batch Array Jobs have a hard ceiling of 10,000 tasks. For anything larger, Variant B is the answer.

## Variant B — SQS + ECS Fargate (Best for High Volume, Always-On)

This is the variant I recommend for production workloads at scale. When an object lands in S3, a Lambda function pushes a message to an SQS queue. ECS Fargate tasks poll that queue, pick up one message at a time, process the file, and delete the message on success. If something fails, SQS automatically retries up to a configurable limit, then routes the message to a Dead Letter Queue (DLQ).

The ECS service auto scales on queue depth — zero tasks when idle, scaling up aggressively when work arrives, and scaling back down after the queue drains. I have processed over 169,000 files through this setup without a single manual intervention.

## The Heart of the System (worker.py or can be any script or logic or light weight executable):

This is the piece I am most proud of. The worker is a single Python file that reads two environment variables — WORKER\_MODE (either “sqs” or “batch”) — and then handles all the orchestration internally. In my original implementation I used it for video processing: downloading an MP4 from S3, extracting audio with FFMPEG, transcribing it with OpenAI Whisper, generating alt-text with GPT-4o Vision, and writing the results back to an output bucket as JSON.
