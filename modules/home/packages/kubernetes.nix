{ pkgs }:

with pkgs;
[
  kubectl
  kubectx
  # the attribute is `kubernetes-helm`; a bare `helm` does not resolve.
  kubernetes-helm
  kustomize
  k9s
  kubent
  kubeconform
  chart-testing
  argocd
  cue
]
