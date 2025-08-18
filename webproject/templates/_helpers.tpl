{{- define "webproject.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "webproject.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "webproject.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "webproject.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "webproject.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "webproject.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
default
{{- end -}}
{{- end -}}

{{/*
  Génère (ou réutilise) une clé random base64 pour un Secret :
  usage: include "webproject.secretOrRand" (list .Release.Namespace "secret-name" "key" 64)
*/}}
{{- define "webproject.secretOrRand" -}}
{{- $ns := index . 0 -}}
{{- $name := index . 1 -}}
{{- $key := index . 2 -}}
{{- $len := index . 3 -}}
{{- $existing := (lookup "v1" "Secret" $ns $name) -}}
{{- if $existing -}}
{{- index $existing.data $key -}}
{{- else -}}
{{- randAlphaNum $len | b64enc -}}
{{- end -}}
{{- end -}}

{{/* Nom du Secret des SALTS de WordPress A */}}
{{- define "webproject.wpASalts.name" -}}
{{- if .Values.secrets.wpASalts.existingSecretName -}}
{{ .Values.secrets.wpASalts.existingSecretName }}
{{- else -}}
{{ include "webproject.fullname" . }}-wp-a-salts
{{- end -}}
{{- end }}

{{/* Nom du Secret des SALTS de WordPress B */}}
{{- define "webproject.wpBSalts.name" -}}
{{- if .Values.secrets.wpBSalts.existingSecretName -}}
{{ .Values.secrets.wpBSalts.existingSecretName }}
{{- else -}}
{{ include "webproject.fullname" . }}-wp-b-salts
{{- end -}}
{{- end }}

{{/* Nom du Secret DB monolithique */}}
{{- define "webproject.dbSecretName" -}}
{{ include "webproject.fullname" . }}-db-credentials
{{- end }}
