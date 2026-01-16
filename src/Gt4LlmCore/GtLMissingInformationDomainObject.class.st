Class {
	#name : #GtLMissingInformationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'receiverName',
		'missingModelName'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMissingInformationDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMissingInformationDomainObject: self
]

{ #category : #'api - testing' }
GtLMissingInformationDomainObject >> isError [
	^ true
]

{ #category : #'api - accessing' }
GtLMissingInformationDomainObject >> messageText [
	"Return an error message"

	^ '{1} is missing {2}'
		format: {self receiverName.
				self missingModelName}
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> missingModelName [
	^ missingModelName
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> missingModelName: aString [
	"Set a missing model name."

	missingModelName := aString
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> receiverName [
	^ receiverName
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> receiverName: anObject [
	"Set a receiver name that was missing a model."

	receiverName := anObject
]

{ #category : #'api - serializing' }
GtLMissingInformationDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #missingModel put: self missingModelName;
		at: #receiver put: self receiverName;
		yourself
]
