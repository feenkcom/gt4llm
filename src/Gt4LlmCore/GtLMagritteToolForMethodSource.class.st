Class {
	#name : #GtLMagritteToolForMethodSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #descriptions }
GtLMagritteToolForMethodSource >> methodDescriptorDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #methodDescriptor;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodSource >> name [
	^ 'getCodeOfMethod'
]

{ #category : #execution }
GtLMagritteToolForMethodSource >> privatePerformToolCall: aToolCall [
	| arguments methodDescriptor  |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodDescriptor := arguments
			at: 'methodDescriptor'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'methodDescriptor' ].
	
	^ methodDescriptor 
			methodObjectIfMissing: [ :anErrorResult | anErrorResult ]
]
