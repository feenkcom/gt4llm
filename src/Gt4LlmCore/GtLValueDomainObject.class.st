Class {
	#name : #GtLValueDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'value'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLValueDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitValueDomainObject: self
]

{ #category : #'api - serializing' }
GtLValueDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ [ GtLValueSerializer new serializeValue: self value ]
		on: Error
		do: [ :anError | 
			anError
				return: (GtLExceptionDomainObject new
						freeze: anError;
						description: 'Cannot serialize object';
						serializeToOpenAIResponseJsonObject) ]
]

{ #category : #accessing }
GtLValueDomainObject >> value [
	^ value
]

{ #category : #accessing }
GtLValueDomainObject >> value: anObject [
	value := anObject
]
