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
GtLAbstractMagritteFunctionTool >> performToolCall: aToolCall inContext: anExecutionContext [
	| domainObject resultObject |
	
	aToolCall performedByTool: self.
	[
		| arguments |
		
		(self jsonSchemaArgumentValidationErrorsFor: aToolCall) 
			ifNotEmpty: [ :aCollectionOfErrors |
				resultObject := self resultObjectFromDomainObject: aCollectionOfErrors first.
			aToolCall result: resultObject.
			^ resultObject ].
		
		arguments := self parametersDescription
				readGenericDomainObjectsFrom: aToolCall rawArgumentsJsonString.
		aToolCall arguments: arguments 
	]
		on: NeoJSONParseError
		do: [ :anException | 
			aToolCall result: (self  
				resultObjectFromDomainObject:(GtLExceptionDomainObject 
					freeze: anException )).
			^ aToolCall result ].
	
	domainObject := self 
		privatePerformToolCall: aToolCall 
		inContext: anExecutionContext.
	resultObject := self resultObjectFromDomainObject: domainObject.
				
	aToolCall result: resultObject.

	^ resultObject
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> resultObjectFromDomainObject: domainObject [ 

	"Temporary check to enble the new LLM views if used"
	(self class shouldEnableDataViews or: [self isUsingDataViews]) ifTrue: [
		(domainObject llmDataViewsInContext: GtLDataViewContext new)
			ifNotEmpty: [ :llmViews |
				^GTLDataViewWrapperModel new 
					targetObject:  domainObject;
					targetDataView:  llmViews ] ].
		
	^((domainObject isKindOf: GtLDomainObject) not or: [
			domainObject wasMovedToMagritteDescriptions ])
		ifTrue: [
			GtLMagritteBasedModel new
				name: 'Response';
				model: domainObject]
		ifFalse: [ 
			domainObject ].
]
