CREATE TABLE "tasks" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	"title" text NOT NULL,
	"description" text NOT NULL,
	"hex_color" text NOT NULL,
	"uid" uuid NOT NULL,
	"due_at" timestamp,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "tasks" ADD CONSTRAINT "tasks_uid_users_id_fkey" FOREIGN KEY ("uid") REFERENCES "users"("id") ON DELETE CASCADE;