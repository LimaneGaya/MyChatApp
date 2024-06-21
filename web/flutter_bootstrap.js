{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {'renderer': 'canvaskit','canvasKitVariant': 'chromium'},
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
});
