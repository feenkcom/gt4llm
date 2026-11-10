Class {
	#name : #GtLAbstractMagritteFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
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

{ #category : #'gt - extensions' }
GtLAbstractMagritteFunctionTool >> gtParameterDescriptionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parameter descriptions';
		priority: 8;
		items: [ self magritteDescription children ];
		column: 'Accessor' text: [ :aDescription | aDescription accessor selector ];
		column: 'Kind'
			text: [ :aDescription | (aDescription class name withoutPrefix: 'MA') withoutSuffix: 'Description' ];
		column: 'Label' text: [ :aDescription | aDescription label ifNil: [ '' ] ];
		column: 'Required'
			text: [ :aDescription | aDescription isRequired ifTrue: [ 'yes' ] ifFalse: [ '' ] ]
			width: 70;
		column: 'Defined in'
			text: [ :aDescription | 
				(aDescription propertyAt: #definingContext ifAbsent: [ nil ])
					ifNil: [ '' ]
					ifNotNil: [ :aContext | aContext methodSelector ] ];
		send: [ :aDescription | 
			(aDescription propertyAt: #definingContext ifAbsent: [ nil ])
				ifNil: [ aDescription ]
				ifNotNil: [ :aContext | aContext compiledMethod ] ]
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
	
	aToolCall markAsStartedByTool: self.
	
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
		
	aToolCall updateResult: resultObject.

	^ resultObject
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> resultObjectFromDomainObject: domainObject [ 

	^GtLWrappedObjectModel new 
			model:  domainObject
]
