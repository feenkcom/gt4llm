Class {
	#name : #GtLRemoteExampleReportDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'result'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLRemoteExampleReportDomainObject >> result [
	^ result
]

{ #category : #accessing }
GtLRemoteExampleReportDomainObject >> result: anObject [
	result := anObject
]

{ #category : #'api - serializing' }
GtLRemoteExampleReportDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	| aJson |
	aJson := NeoJSONObject new.
	aJson
		at: 'class' put: self result checkName key asString;
		at: 'method' put: self result checkName value asString;
		at: 'result' put: self result shortName.
	result isSuccess
		ifFalse: [ aJson
				at: 'message' put: self result exceptionMessageText;
				at: 'stackTrace' put: self result exceptionTrace ].

	^ aJson
]
