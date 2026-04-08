Class {
	#name : #GtLRemoteExampleReportDomainObject,
	#superclass : #Object,
	#instVars : [
		'result'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt-llm - serialization' }
GtLRemoteExampleReportDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: 'class' put: self result checkName key asString;
			at: 'method' put: self result checkName value asString;
			at: 'result' put: self result shortName.
		result isSuccess
			ifFalse: [ json
					at: 'message' put: self result exceptionMessageText;
					at: 'stackTrace' put: self result exceptionTrace ] ]
]

{ #category : #accessing }
GtLRemoteExampleReportDomainObject >> result [
	^ result
]

{ #category : #accessing }
GtLRemoteExampleReportDomainObject >> result: anObject [
	result := anObject
]
