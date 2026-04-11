resource "aws_s3_bucket" "state_bucket_test" {
    bucket = "test-bucket-april11-2026"
    object_lock_enabled = true
}