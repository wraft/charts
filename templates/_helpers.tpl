{{/*
Expand the name of the chart.
*/}}
{{- define "wraft.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wraft.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wraft.labels" -}}
helm.sh/chart: {{ include "wraft.chart" . }}
{{ include "wraft.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wraft.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wraft.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

