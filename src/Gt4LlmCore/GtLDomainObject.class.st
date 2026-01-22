Class {
	#name : #GtLDomainObject,
	#superclass : #Object,
	#traits : 'TGtLDomainObject',
	#classTraits : 'TGtLDomainObject classTrait',
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitDomainObject: self
]

{ #category : #'gt - extensions' }
GtLDomainObject >> gtJsonObjectViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Serialized content';
		priority: 10;
		object: [ self serializeToOpenAIResponseJsonObject asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtLDomainObject >> gtJsonStringViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'JSON String';
		priority: 11;
		object: [ self serializeToOpenAIResponseJsonObject asGtJson ];
		view: #gtJsonStringFor:
]

{ #category : #'api - testing' }
GtLDomainObject >> isErrorDomainObject [
	"Return true if the domain object represents some kind of failure or exception,
	instead of an expected domain object."

	^ false
]

{ #category : #'api - serializing' }
GtLDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ self subclassResponsibility
]

{ #category : #'api - serializing' }
GtLDomainObject >> serializeToOpenAIResponseJsonString [
	"Return a JSON string that represents the domain object."

	<return: #String>
	^ STONJSON toString: self serializeToOpenAIResponseJsonObject
]

{ #category : #'api - serializing' }
GtLDomainObject >> serializeToOpenAIResponseOutput [
	"Return a JSON that represents tool response output.
	See GtLToolMessage>>#serializeForOpenAIResponsesAPI for more information."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self serializeToOpenAIResponseJsonString;
			at: #type put: #input_text;
			yourself}
]
