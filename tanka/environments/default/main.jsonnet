local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.32/main.libsonnet";
local deploy = k.apps.v1.deployment;
local service = k.core.v1.service;
local container = k.core.v1.container;
local port = k.core.v1.containerPort;

{
  local name = 'whoami',
  whoami: {
    deployment: deploy.new(
      name=name,
      replicas=4,
      containers=[
        container.new(name, image='traefik/whoami:latest') + 
        container.withPorts( [ port.newNamed(80, name)])
        + container.securityContext.withAllowPrivilegeEscalation(false)
        + container.securityContext.seccompProfile.withType('RuntimeDefault')
        + container.securityContext.withRunAsNonRoot(false)
        + container.securityContext.capabilities.withDrop(['ALL'])

      ], 
    ),

    service: service.new(
      name,
      selector={name: name}, 
      ports=[{port: 80}]
    ),
  }
}
