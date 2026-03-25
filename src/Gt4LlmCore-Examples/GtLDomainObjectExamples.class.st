Class {
	#name : #GtLDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
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
	aJsonObject := aDomainObject serializeToLlmJsonObject.

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

{ #category : #examples }
GtLDomainObjectExamples >> genericJSONSchemaValidationErrorDomainObject [
	<gtExample>
	| domainObject jsonObject path |
	path := #('methodDescriptor' 'methodClassName').
	domainObject := GtLJSONSchemaValidationErrorDomainObject new
		path: path;
		errorMessage: 'Invalid JSON schema'.

	self assert: domainObject isErrorDomainObject.
	self assert: domainObject path equals: path.
	self assert: domainObject errorMessage equals: 'Invalid JSON schema'.

	jsonObject := domainObject serializeToLlmJsonObject.
	self
		assert: (jsonObject at: 'errorMessage')
		equals: 'Invalid JSON schema'.
	self
		assert: (jsonObject at: 'path') asArray
		equals: path asArray.

	^ domainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingArgumentDomainObject [
	<gtExample>
	| domainObject jsonObject |
	domainObject := GtLMissingArgumentDomainObject new
			missingArgument: 'className';
			arguments: (OrderedDictionary new
					at: #argumentOne put: 108;
					yourself).
					
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject missingArgument
		equals: 'className'.
	self
		assert: domainObject errorMessage
		equals: 'Missing argument called className'.
	
	jsonObject := domainObject serializeToLlmJsonObject.
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'missingArgument' 
				put: 'className'; 
			at: 'errorMessage'
				put: 'Missing argument called className';
			yourself).


	^ domainObject
]

{ #category : #'examples - class' }
GtLDomainObjectExamples >> missingDomainObject [
	<gtExample>
	| domainObject jsonObject |
	domainObject := GtLMissingDomainObject new 
		objectName: GtLDummyOneObject name.
		
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject missingObjectName
		equals: 'GtLDummyOneObject'.
	self
		assert: domainObject errorMessage
		equals: 'GtLDummyOneObject is not found'.
	
	jsonObject := domainObject serializeToLlmJsonObject.
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'missingObjectName' 
				put: 'GtLDummyOneObject'; 
			at: 'errorMessage'
				put: 'GtLDummyOneObject is not found';
			yourself).

	^ domainObject
]

{ #category : #examples }
GtLDomainObjectExamples >> missingRequiredPropertiesDomainObject [
	<gtExample>
	| domainObject jsonObject missingPropertyNames path |
	missingPropertyNames := #('methodClassName' 'methodName').
	path := #('methodDescriptor').
	domainObject := GtLMissingRequiredPropertiesDomainObject new
		missingPropertyNames: missingPropertyNames;
		path: path;
		errorMessage: 'Missing required properties in methodDescriptor'.

	self assert: domainObject isErrorDomainObject.
	self assert: domainObject missingPropertyNames equals: missingPropertyNames.
	self assert: domainObject path equals: path.
	self assert: domainObject errorMessage equals: 'Missing required properties in methodDescriptor'.

	jsonObject := domainObject serializeToLlmJsonObject.
	self
		assert: (jsonObject at: 'errorMessage')
		equals: 'Missing required properties in methodDescriptor'.
	self
		assert: (jsonObject at: 'missingPropertyNames') asArray
		equals: missingPropertyNames asArray.
	self
		assert: (jsonObject at: 'path') asArray
		equals: path asArray.

	^ domainObject
]
