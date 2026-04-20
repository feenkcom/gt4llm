Class {
	#name : #GtLAbstractMagritteFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractMagritteFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractMagritteFunctionTool
]

{ #category : #accessing }
GtLAbstractMagritteFunctionTool >> computeParametersFormat [
	^ self parametersDescription
]

{ #category : #'as yet unclassified' }
GtLAbstractMagritteFunctionTool >> gtMagritteFor: aView [
	"do not show the view"
	^ aView	empty
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> jsonSchemaArgumentValidationErrorsFor: aToolCall [
	| parameters schema validator |
	parameters := self parametersDescription.
	schema := parameters schema.

	validator := schema validator.
	validator validate: aToolCall rawArgumentsJsonObject.
	^ validator validationErrors collect: [ :each |
		each asGtLErrorReturnObject ]
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> parametersDescription [
	^ GtLResponseMagritteFormat new
			name: 'Parameters';
			modelClass: self class
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> resultObjectFromDomainObject: domainObject [ 

	^GTLDataViewWrapperModel new 
			targetObject:  domainObject;
			targetDataViews:  (domainObject 
				llmDataViewsInContext: GtLDataViewContext new)
]
