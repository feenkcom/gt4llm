Class {
	#name : #GtLDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - class' }
GtLDomainObjectExamples >> classDomainObject [
	<gtExample>
	| aDomainObject aJsonObject aValidator |
	aDomainObject := GtLClassDomainObject new foundClass: GtLDummyOneObject.
	aJsonObject := aDomainObject serializeToOpenAIResponseJsonObject.

	aValidator := GtLValueSerializer new validateClass: aJsonObject.
	self assert: aValidator isValid.

	^ aDomainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingArgumentDomainObject [
	<gtExample>
	| aDomainObject aJsonObject |
	aDomainObject := GtLMissingArgumentDomainObject new
			receiverName: 'lookupClass';
			missingArgument: 'className';
			arguments: (OrderedDictionary new
					at: #argumentOne put: 108;
					yourself).
	aJsonObject := aDomainObject serializeToOpenAIResponseJsonObject.

	^ aDomainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingDomainObject [
	<gtExample>
	| aDomainObject aJsonObject |
	aDomainObject := GtLMissingDomainObject new objectName: GtLDummyOneObject name.
	aJsonObject := aDomainObject serializeToOpenAIResponseJsonObject.

	^ aDomainObject
]
