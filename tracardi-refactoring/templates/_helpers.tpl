{{/*
Expand the name of the chart.
*/}}
{{- define "tracardi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tracardi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tracardi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "tracardi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tracardi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Resource labels
Params:
  ctx = . context
  component = component name (optional)
*/}}
{{- define "tracardi.labels" -}}
helm.sh/chart: {{ include "tracardi.chart" .ctx }}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- if .ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end -}}

{{/*
Service selector labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "tracardi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}


{{/*
POD labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "tracardi.podLabels" -}}
helm.sh/chart: {{ include "tracardi.chart" .ctx }}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Common Env Var
Params:
  ctx = . context
  license = name of secret containing the license
*/}}
{{- define "tracardi.env" -}}
- name: ELASTIC_SCHEME
  value: {{ .ctx.Values.elastic.schema | quote }}
- name: ELASTIC_HOST
  value: {{ .ctx.Values.elastic.host }}
- name: ELASTIC_HTTP_AUTH_USERNAME
  value: {{ .ctx.Values.elastic.username }}
- name: ELASTIC_HTTP_AUTH_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.elastic.existingSecret }}
      key: {{ .ctx.Values.elastic.existingSecretPasswordKey }}
- name: ELASTIC_PORT
  value: {{ .ctx.Values.elastic.port | quote }}
- name: ELASTIC_VERIFY_CERTS
  value: {{ .ctx.Values.elastic.verifyCerts | quote }}
- name: ELASTIC_QUERY_TIMEOUT
  value: "120"
- name: REDIS_HOST
  value: {{ .ctx.Values.redis.host }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.redis.existingSecret }}
      key: {{ .ctx.Values.redis.existingSecretPasswordKey }}
- name: SOURCE_CACHE_TTL
  value: "60"
- name: SESSION_CACHE_TTL
  value: "60"
- name: EVENT_TAG_CACHE_TTL
  value: "60"
- name: EVENT_VALIDATION_CACHE_TTL
  value: "60"
- name: _DEBUG_VERSION
  value: "{{ .ctx.Chart.AppVersion }}"
{{- if .license }}
- name: LICENSE
  valueFrom:
    secretKeyRef:
      name: {{ .license }}
      key: key
{{- end }}
{{- end -}}