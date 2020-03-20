output pipeline_s3_id {
  value = aws_s3_bucket.source.id
}

output pipeline_id {
  value = aws_codepipeline.pipeline.id
}