"
Trait providing assertion methods for testing erroneous condition domain objects.
"
Trait {
	#name : #TGtLInvalidInputDataAssertions,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertIncorrectArgumentType: aDomainObject withArgumentName: anArgumentName argumentValue: anArgumentValue expectedKind: aClass [
	"Assert that the domain object is a GtLIncorrectArgumentTypeDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLIncorrectArgumentTypeDomainObject).
	self assert: aDomainObject argumentName equals: anArgumentName.
	self assert: aDomainObject argumentValue equals: anArgumentValue.
	self assert: aDomainObject expectedArgumentValueKind equals: aClass
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertJSONSchemaValidationError: aDomainObject withPath: aPath errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLJSONSchemaValidationErrorDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: aDomainObject path equals: aPath.
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertMissingArgument: aDomainObject withArgumentName: anArgumentName errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLMissingArgumentDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLMissingArgumentDomainObject).
	self assert: aDomainObject missingArgument equals: anArgumentName.
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertMissingInformation: aDomainObject withModelName: aModelName errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLMissingInformationDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLMissingInformationDomainObject).
	self assert: aDomainObject missingModelName equals: aModelName.
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertMissingObject: aDomainObject withObjectName: anObjectName errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLMissingDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLMissingDomainObject).
	self assert: aDomainObject objectName equals: anObjectName.
	self assert: aDomainObject missingObjectName equals: anObjectName.
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertMissingRequiredProperties: aDomainObject withPropertyNames: propertyNames path: aPath errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLMissingRequiredPropertiesDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: aDomainObject missingPropertyNames equals: propertyNames.
	self assert: aDomainObject path equals: aPath.
	self assert: aDomainObject errorMessage equals: anErrorMessage.
	self assert: aDomainObject messageText equals: anErrorMessage
]

{ #category : #assertions }
TGtLInvalidInputDataAssertions >> assertUnexpectedObject: aDomainObject withObjectName: anObjectName errorMessage: anErrorMessage [
	"Assert that the domain object is a GtLUnexpectedDomainObject with expected values."
	
	self assert: aDomainObject isErrorDomainObject.
	self assert: (aDomainObject isKindOf: GtLUnexpectedDomainObject).
	self assert: aDomainObject objectName equals: anObjectName.
	self assert: aDomainObject messageText equals: anErrorMessage
]
