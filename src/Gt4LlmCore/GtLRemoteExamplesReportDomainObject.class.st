Class {
	#name : #GtLRemoteExamplesReportDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'errorMessages',
		'results',
		'exception'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - initialization' }
GtLRemoteExamplesReportDomainObject >> errorMessage: aString [
	self errorMessages: (self errorMessages copyWith: aString)
]

{ #category : #accessing }
GtLRemoteExamplesReportDomainObject >> errorMessages [
	<return: #Array of: #String>
	^ errorMessages ifNil: [ errorMessages := #() ]
]

{ #category : #'api - initialization' }
GtLRemoteExamplesReportDomainObject >> errorMessages: aCollectionOfStrings [
	errorMessages := aCollectionOfStrings
]

{ #category : #accessing }
GtLRemoteExamplesReportDomainObject >> exception [
	^ exception
]

{ #category : #accessing }
GtLRemoteExamplesReportDomainObject >> exception: anObject [
	exception := anObject
]

{ #category : #'api - initialization' }
GtLRemoteExamplesReportDomainObject >> freeze: anException [
	self exception: (GtSystemUtility freeze: anException)
]

{ #category : #accessing }
GtLRemoteExamplesReportDomainObject >> results [
	<return: #Array of: #GtLRemoteExampleReportDomainObject>
	^ results ifNil: [ #() ]
]

{ #category : #'api - initialization' }
GtLRemoteExamplesReportDomainObject >> results: anObject [
	results := anObject
]

{ #category : #'api - serializing' }
GtLRemoteExamplesReportDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	| aJson |
	aJson := NeoJSONObject new.
	self errorMessages
		ifNotEmpty: [ :aCollection | aJson at: #errors put: aCollection ].
	self results ifNotEmpty: [ :aCollection | aJson at: #results put: aCollection ].
	self exception
		ifNotNil: [ aJson
				at: #error
				put: (NeoJSONObject new
						at: #message put: self exception messageText;
						at: #stackTrace put: self stackTrace;
						yourself) ].

	^ aJson
]

{ #category : #accessing }
GtLRemoteExamplesReportDomainObject >> stackTrace [
	self exception ifNil: [ ^ nil ].
	
	^ String streamContents: [ :stream |
		self exception signalerContext errorReportOn: stream ]
]
