Class {
	#name : #GtLDomainObjectExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLDomainObjectExamples >> classDomainObject [
	<gtExample>
	| aDomainObject aJsonObject aValidator |
	aDomainObject := GtLClassDomainObject new
		foundClass: GtLDummyOneObject;
		originalClassName: 'GtLDummyOneObject';
		originalSuperclassName: 'Object';
		originalPackageName: 'Gt4LlmCore-Examples';
		originalInstanceVariableNames: 'instVarA instVarB';
		originalClassVariableNames: 'classInstVarA classInstVarB';
		originalTraitCompositionString: Behavior traitCompositionString;
		yourself.
	aJsonObject := aDomainObject serializeToOpenAIResponseJsonObject.

	aValidator := GtLValueSerializer new validateClass: aJsonObject.
	self assert: aValidator isValid.
	self assert: aDomainObject originalClassName equals: 'GtLDummyOneObject'.
	self assert: aDomainObject originalSuperclassName equals: 'Object'.
	self assert: aDomainObject originalPackageName equals: 'Gt4LlmCore-Examples'.
	self assert: aDomainObject originalInstanceVariableNames equals: 'instVarA instVarB'.
	self assert: aDomainObject originalClassVariableNames equals: 'classInstVarA classInstVarB'.
	self assert: aDomainObject originalTraitCompositionString equals: Behavior traitCompositionString.

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
