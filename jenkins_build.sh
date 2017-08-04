#!/bin/sh

set -eux

bash install_protoc.sh /build/proto

cd /go/src/github.com/stripe/sequins
PATH=/build/proto/bin:$PATH make sequins vet

./sequins --help 2>&1 | grep usage && echo 'binary looks good'

mkdir -p /build/bin/
cp -a sequins /build/bin/

# persist schemas to S3; we may later obsolete this with tooling that makes
# this happens automatically for anything in a proto/ directory
SCHEMAS_OUT="s3://stripe-data/schemas/proto/sequins/$(git rev-parse --abbrev-ref HEAD)/$(git rev-parse HEAD)"
aws s3 cp proto/rpc.proto "$SCHEMAS_OUT/rpc.proto"
aws s3 cp proto/rpc.proto vendor/google.golang.org/grpc/health/grpc_health_v1/health.proto "$SCHEMAS_OUT/health.proto"

echo "DONE"
