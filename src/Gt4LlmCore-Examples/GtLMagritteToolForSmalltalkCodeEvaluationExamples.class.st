"
Examples for GtLMagritteToolForSmalltalkCodeEvaluation.
"
Class {
	#name : #GtLMagritteToolForSmalltalkCodeEvaluationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples',
	#classTraits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> argumentsHaveStringKeys [
	"The arguments of a performed tool call have String keys, like those of a tool call that was only parsed
	(GtLFunctionToolCall>>#arguments reads the raw arguments with STONJSON)"

	<gtExample>
	<return: #GtLFunctionToolCall>
	| call parsedCall |
	call := self executeSimpleDoIt.
	self assert: call arguments keys isNotEmpty.
	self assert: (call arguments keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	self assert: (call arguments at: 'code') equals: '1 + 2'.

	parsedCall := GtLFunctionToolCall new
			rawArguments: call rawArgumentsJsonString;
			yourself.
	self assert: (parsedCall arguments keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	self assert: parsedCall arguments keys asSortedCollection asArray equals: call arguments keys asSortedCollection asArray.
	^ call
]

{ #category : #asserting }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertExceptionDomainObject: aDomainObject withExceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	self assert: aDomainObject exception class equals: anExceptionClass.
	self assert: (aDomainObject messageText includesSubstring: aMessageSubstring).
]

{ #category : #asserting }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertPlaygroundPageReference: aPlaygroundPageReference [
	<gsCode: '	self assert: aPlaygroundPageReference isNil.'>
	self assert: aPlaygroundPageReference notNil.

	self
		assert: aPlaygroundPageReference databaseId
		equals: self theDatabase primaryDB uuidString.
	self
		assert: aPlaygroundPageReference pageUid
		equals: self theDatabase pages first uid asString36
]

{ #category : #'private - examples' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertReplayOf: aScript in: aStorage equals: anObject [
	self
		gtDo: [ | viewModel bindings result |
			viewModel := (GtPharoSnippetCoder forSource: aScript) asCoderViewModel.
			bindings := GtSharedVariablesBindings new.
			(bindings bindingOf: #objectStorage) value: aStorage.
			viewModel sharedBindings: bindings.
			result := viewModel coderModel doItInContext: viewModel evaluationContext all.
			self assert: result isSuccess.
			self assert: result value equals: anObject ]
		gemstoneDo: [  ]
]

{ #category : #assertions }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertSmalltalkCodeEvaluationException: aDomainObject withCode: aCodeString exceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	"Assert that the domain object is a GtLSmalltalkCodeEvaluationExceptionDomainObject with expected values."
	
	self assert: (aDomainObject isKindOf: GtLSmalltalkCodeEvaluationExceptionDomainObject).
	self assert: aDomainObject code equals: aCodeString.
	self assert: aDomainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self 
		assertExceptionDomainObject: aDomainObject 
		withExceptionClass: anExceptionClass 
		messageSubstring: aMessageSubstring
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> emptyCodeArgument [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''   ''.
			''bindings'' -> #()
			} asDictionary
		inContext: GtLToolExecutionContext new.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: ''code''
		errorMessage: ''Missing argument called code''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '   '.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'code'
		errorMessage: 'Missing argument called code'.
	^ call
]

{ #category : #private }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> ensureLepiterPageForObject: anObject withSnippetCode: aString [
	self lepiterPageReferenceForObject: anObject withSnippetCode: aString
]

{ #category : #'private - examples' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> evaluateProvenanceCode: aString bindings: someBindings in: aStorage [
	| toolCall |
	toolCall := self
			executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
			withArguments: {'code' -> aString.
					'bindings'
						-> (someBindings
								collect: [ :each | 
									{'name' -> each key.
										'objectId' -> each value} asDictionary ])} asDictionary
			inContext: (GtLToolExecutionContext new objectStorage: aStorage).
	^ aStorage storedObjectAt: toolCall result targetObject objectId
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningBlElement [
	"Test execution that returns a BlElement, which has image views."

	<gtExample>
	<return: #GtLFunctionToolCall>
	| objectStorage tool call targetObject objectValue |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: BlElement new withSnippetCode: 'BlElement new'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
			executeTool: tool
			withArguments: {'code' -> 'BlElement new'.
					'bindings' -> #()} asDictionary
			inContext: (GtLToolExecutionContext new
					objectStorage: objectStorage;
					lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: BlElement).
	self assert: targetObject code equals: 'BlElement new'.
	self assert: targetObject playgroundPageReference notNil.
	self
		assert: targetObject playgroundPageReference databaseId
		equals: self theDatabase primaryDB uuidString.
	self
		assert: targetObject playgroundPageReference pageUid
		equals: self theDatabase pages first uid asString36.
	objectValue := targetObject objectValue.
	self assert: objectValue objectClassName equals: 'BlElement'.
	self assert: objectValue superclassName equals: 'Object'.
	self assert: objectValue packageName equals: 'Bloc'.
	self assert: objectValue phlowViews isNotEmpty.
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Preview' ]).
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Print' ]).
	self assert: objectValue allInstanceSlots isNotEmpty.
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self
		assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlots [
	"Test execution that returns an object with slots and views."

	<gsCode: '	<gtExample>
	"Test execution that returns an object with slots and views."
	| objectStorage tool call targetObject objectValue storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''GtLSerializedObjectValueTestObject exampleInstance''.
			''bindings'' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: GtLSerializedObjectValueTestObject).
	self assert: targetObject object name equals: ''TestObject''.
	self assert: targetObject object count equals: 42.
	self assert: targetObject object items equals: #(''apple'' ''banana'' ''cherry'').
	self assert: targetObject playgroundPageReference isNil.
	objectValue := targetObject objectValue.
	self assert: objectValue objectClassName equals: ''GtLSerializedObjectValueTestObject''.
	self assert: objectValue superclassName equals: ''Object''.
	self assert: objectValue packageName equals: ''Gt4LlmCore-Examples''.
	self assert: (objectValue objectPrintString includesSubstring: ''TestObject'').
	self assert: objectValue phlowViews isEmpty.
	self assert: objectValue allInstanceSlots size equals: 3.
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = ''name'' and: [ s valueClassName = ''String'' ] ]).
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = ''count'' and: [ s valuePrintString = ''42'' ] ]).
	self assert: targetObject objectId isNotEmpty.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: ''GtLSerializedObjectValueTestObject exampleInstance''.
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject objectValue storedResult |
	objectStorage := GtLObjectStorage new.
	self
		ensureLepiterPageForObject: GtLSerializedObjectValueTestObject exampleInstance
		withSnippetCode: 'GtLSerializedObjectValueTestObject exampleInstance'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
			executeTool: tool
			withArguments: {'code'
						-> 'GtLSerializedObjectValueTestObject exampleInstance'.
					'bindings' -> #()} asDictionary
			inContext: (GtLToolExecutionContext new
					objectStorage: objectStorage;
					lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: GtLSerializedObjectValueTestObject).
	self assert: targetObject object name equals: 'TestObject'.
	self assert: targetObject object count equals: 42.
	self assert: targetObject object items equals: #('apple' 'banana' 'cherry').
	self assert: targetObject playgroundPageReference notNil.
	self
		assert: targetObject playgroundPageReference databaseId
		equals: self theDatabase primaryDB uuidString.
	self
		assert: targetObject playgroundPageReference pageUid
		equals: self theDatabase pages first uid asString36.
	objectValue := targetObject objectValue.
	self
		assert: objectValue objectClassName
		equals: 'GtLSerializedObjectValueTestObject'.
	self assert: objectValue superclassName equals: 'Object'.
	self assert: objectValue packageName equals: 'Gt4LlmCore-Examples'.
	self assert: (objectValue objectPrintString includesSubstring: 'TestObject').
	self assert: objectValue phlowViews isNotEmpty.
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Details' ]).
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Items' ]).
	self assert: objectValue allInstanceSlots size equals: 3.
	self
		assert: (objectValue allInstanceSlots
				anySatisfy: [ :s | s name = 'name' and: [ s valueClassName = 'ByteString' ] ]).
	self
		assert: (objectValue allInstanceSlots
				anySatisfy: [ :s | s name = 'count' and: [ s valuePrintString = '42' ] ]).
	self assert: targetObject objectId isNotEmpty.
	self
		assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self
		assert: storedResult reason class
		equals: GtLStoredObjectCodeExecutionReason.
	self
		assert: storedResult reason asReasonString
		equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlotsSerialization [
	"Test that the result serializes correctly to JSON."

	<gsCode: '	<gtExample>
	"Test that the result serializes correctly to JSON."
	| call jsonObject objectValue slots pageReference |
	call := self executeReturningObjectWithSlots.
	jsonObject := GtMagritteJSONDataExporter exportObject: call result targetObject.
	self assert: (jsonObject at: ''code'') equals: ''GtLSerializedObjectValueTestObject exampleInstance''.
	self assert: (jsonObject at: ''objectId'') isNotEmpty.
	pageReference := jsonObject at: ''playgroundPageReference'' ifAbsent: [ nil ].
	self assert: pageReference isNil.
	objectValue := jsonObject at: ''objectValue''.
	self assert: (objectValue at: ''objectClassName'') equals: ''GtLSerializedObjectValueTestObject''.
	self assert: (objectValue at: ''superclassName'') equals: ''Object''.
	self assert: (objectValue at: ''packageName'') equals: ''Gt4LlmCore-Examples''.
	self assert: (objectValue at: ''phlowViews'') isEmpty.
	slots := objectValue at: ''allInstanceSlots''.
	self assert: slots size equals: 3.
	self assert: (slots anySatisfy: [ :s | 
		(s at: ''name'') = ''name'' 
			and: [ (s at: ''valueClassName'') = ''String''
				and: [ (s at: ''valuePrintString'') = ''TestObject'' ] ] ]).
	self assert: (slots anySatisfy: [ :s | 
		(s at: ''name'') = ''count'' 
			and: [ (s at: ''valueClassName'') = ''SmallInteger''
				and: [ (s at: ''valuePrintString'') = ''42'' ] ] ]).
	^ jsonObject'>
	<gtExample>
	| call jsonObject objectValue slots pageReference |
	call := self executeReturningObjectWithSlots.
	jsonObject := GtMagritteJSONDataExporter exportObject: call result targetObject.
	self
		assert: (jsonObject at: 'code')
		equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	self assert: (jsonObject at: 'objectId') isNotEmpty.
	pageReference := jsonObject at: 'playgroundPageReference'.
	self
		assert: (pageReference at: 'databaseId')
		equals: self theDatabase primaryDB uuidString.
	self assert: (pageReference at: 'pageUid') isNotEmpty.
	objectValue := jsonObject at: 'objectValue'.
	self
		assert: (objectValue at: 'objectClassName')
		equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValue at: 'superclassName') equals: 'Object'.
	self assert: (objectValue at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	self assert: (objectValue at: 'phlowViews') isNotEmpty.
	self
		assert: ((objectValue at: 'phlowViews') anySatisfy: [ :v | (v at: 'title') = 'Details' ]).
	slots := objectValue at: 'allInstanceSlots'.
	self assert: slots size equals: 3.
	self
		assert: (slots
				anySatisfy: [ :s | 
					(s at: 'name') = 'name'
						and: [ (s at: 'valueClassName') = 'ByteString'
								and: [ (s at: 'valuePrintString') = 'TestObject' ] ] ]).
	self
		assert: (slots
				anySatisfy: [ :s | 
					(s at: 'name') = 'count'
						and: [ (s at: 'valueClassName') = 'SmallInteger'
								and: [ (s at: 'valuePrintString') = '42' ] ] ]).
	^ jsonObject
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoIt [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''1 + 2''.
			''bindings'' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: ''1 + 2''.
	
	self assert: targetObject objectValue objectClassName equals: ''SmallInteger''.
	self assert: targetObject objectValue objectPrintString equals: ''3''.
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds anyOne) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: ''1 + 2''.
	
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: 3 withSnippetCode: '1 + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 + 2'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithNoBindingKey [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''1 + 2''.
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: ''1 + 2''.
	self assert: targetObject objectValue objectClassName equals: ''SmallInteger''.
	self assert: targetObject objectValue objectPrintString equals: ''3''.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference isNil.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds anyOne) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: ''1 + 2''.
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: 3 withSnippetCode: '1 + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
			executeTool: tool
			withArguments: {'code' -> '1 + 2'} asDictionary
			inContext: (GtLToolExecutionContext new
					objectStorage: objectStorage;
					lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference notNil.
	self
		assert: targetObject playgroundPageReference databaseId
		equals: self theDatabase primaryDB uuidString.
	self
		assert: targetObject playgroundPageReference pageUid
		equals: self theDatabase pages first uid asString36.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self
		assert: storedResult reason class
		equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 + 2'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutLepiterPage [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''Object new''.
			''bindings'' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: Object).
	self assert: targetObject playgroundPageReference isNil.
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'LePage new'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: LePage).
	self assert: targetObject playgroundPageReference isNil.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutObjectStorage [
	<gsCode: '	<gtExample>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''1 + 2''.
			''bindings'' -> #()
			} asDictionary
		inContext: GtLToolExecutionContext new.
			
	self assert: (call result targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: call result targetObject object equals: 3.
	self assert: call result targetObject code equals: ''1 + 2''.
	self assert: call result targetObject objectId equals: ''''.
	^ call'>
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
			
	self assert: (call result targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: call result targetObject object equals: 3.
	self assert: call result targetObject code equals: '1 + 2'.
	self assert: call result targetObject objectId equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyName [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty name is handled."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''''. ''objectId'' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertSmalltalkCodeEvaluationException: call result targetObject
		withCode: ''value + 2''
		exceptionClass: CompileError
		messageSubstring: ''undefined symbol''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty name is handled."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> ''. 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertSmalltalkCodeEvaluationException: call result targetObject
		withCode: 'value + 2'
		exceptionClass: RBParser gtParseErrorClass
		messageSubstring: 'Undeclared variable'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyObjectId [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty objectId is handled."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''value''. ''objectId'' -> '''' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: ''''
		errorMessage: '' is not found''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty objectId is handled."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> '' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingObject: call result targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingName [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing name is handled - returns missing required properties error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''objectId'' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #(''name'')
		path: #(''bindings'' 1)
		errorMessage: ''@[bindings/1] required properties missing [name]''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing name is handled - returns missing required properties error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('name')
		path: #('bindings' 1)
		errorMessage: '@[bindings/1] required properties missing [name]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingObjectId [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing objectId is handled - returns missing required properties error."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''value'' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #(''objectId'')
		path: #(''bindings'' 1)
		errorMessage: ''@[bindings/1] required properties missing [objectId]''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing objectId is handled - returns missing required properties error."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #('bindings' 1)
		errorMessage: '@[bindings/1] required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilName [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil name is handled - returns JSON schema validation error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> nil. ''objectId'' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(''bindings'' 1 ''name'')
		errorMessage: ''@[bindings/1/name] string expected''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil name is handled - returns JSON schema validation error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> nil. 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('bindings' 1 'name')
		errorMessage: '@[bindings/1/name] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilObjectId [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil objectId is handled - returns JSON schema validation error."
	| objectStorage tool call |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''value''. ''objectId'' -> nil } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(''bindings'' 1 ''objectId'')
		errorMessage: ''@[bindings/1/objectId] string expected''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil objectId is handled - returns JSON schema validation error."
	| objectStorage tool call |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> nil } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('bindings' 1 'objectId')
		errorMessage: '@[bindings/1/objectId] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindings [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject bindingObjectId resultObjectId storedResult |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''value''. ''objectId'' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 42.
	self assert: targetObject playgroundPageReference isNil.
	resultObjectId := targetObject objectId.
	self assert: resultObjectId isNotEmpty.
	self assert: resultObjectId ~= bindingObjectId.
	self assert: (objectStorage objectAt: bindingObjectId) equals: 40.
	self assert: (objectStorage objectAt: resultObjectId) equals: 42.
	storedResult := objectStorage storedObjectAt: resultObjectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: ''value + 2''.
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject bindingObjectId resultObjectId storedResult |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	self ensureLepiterPageForObject: 42 withSnippetCode: 'value + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
			executeTool: tool
			withArguments: {'code' -> 'value + 2'.
					'bindings'
						-> {{'name' -> 'value'.
									'objectId' -> bindingObjectId} asDictionary} asArray} asDictionary
			inContext: (GtLToolExecutionContext new
					objectStorage: objectStorage;
					lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 42.
	self assert: targetObject playgroundPageReference notNil.
	self
		assert: targetObject playgroundPageReference databaseId
		equals: self theDatabase primaryDB uuidString.
	self
		assert: targetObject playgroundPageReference pageUid
		equals: self theDatabase pages first uid asString36.
	resultObjectId := targetObject objectId.
	self assert: resultObjectId isNotEmpty.
	self assert: resultObjectId ~= bindingObjectId.
	self assert: (objectStorage objectAt: bindingObjectId) equals: 40.
	self assert: (objectStorage objectAt: resultObjectId) equals: 42.
	storedResult := objectStorage storedObjectAt: resultObjectId.
	self
		assert: storedResult reason class
		equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: 'value + 2'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingsMissingObjectStorage [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	| call |
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			''code'' -> ''value + 2''.
			''bindings'' -> {
				{ ''name'' -> ''value''. ''objectId'' -> ''missing'' } asDictionary
			} asArray
			} asDictionary
		inContext: GtLToolExecutionContext new.
	self
		assertMissingInformation: call result targetObject
		withModelName: ''objectStorage''
		errorMessage: ''Missing objectStorage''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	| call |
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> 'missing' } asDictionary
			} asArray
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''1 / 0''.
			''bindings'' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: ''1 / 0''
		exceptionClass: ZeroDivide
		messageSubstring: ''ZeroDivide''.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: ''ZeroDivide''.
	self assert: (targetObject objectValue objectPrintString includesSubstring: ''ZeroDivide'').
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: ((objectStorage objectAt: objectStorage objectIds anyOne) isKindOf: ZeroDivide).
	
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: ''1 / 0''.
	
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: ZeroDivide new withSnippetCode: '1 / 0'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 / 0'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: '1 / 0'
		exceptionClass: ZeroDivide
		messageSubstring: 'ZeroDivide'.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'ZeroDivide'.
	self assert: targetObject objectValue objectPrintString equals: 'ZeroDivide'.
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: ((objectStorage objectAt: objectStorage objectIds first) isKindOf: ZeroDivide).
	
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 / 0'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithErrorWithoutLepiterPage [
	<gsCode: '	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''code'' -> ''Object new error: ''''boom''''''.
			''bindings'' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: ''Object new error: ''''boom''''''
		exceptionClass: UserDefinedError
		messageSubstring: ''boom''.
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: ''UserDefinedError''.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference isNil.
	^ call'>
	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'LePage new error: ''boom'''.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: 'LePage new error: ''boom'''
		exceptionClass: Error
		messageSubstring: 'boom'.
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'Error'.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference isNil.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithErrorWithoutObjectStorage [
	<gsCode: '	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
					''code'' -> ''1 / 0''.
			''bindings'' -> #()
			} asDictionary
		inContext: GtLToolExecutionContext new.
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: ''1 / 0''
		exceptionClass: ZeroDivide
		messageSubstring: ''ZeroDivide''.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: ''ZeroDivide''.
	self assert: (targetObject objectValue objectPrintString includesSubstring: ''ZeroDivide'').
	self assert: targetObject objectId equals: ''''.
	
	^ call'>
	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
					'code' -> '1 / 0'.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: '1 / 0'
		exceptionClass: ZeroDivide
		messageSubstring: 'ZeroDivide'.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'ZeroDivide'.
	self assert: targetObject objectValue objectPrintString equals: 'ZeroDivide'.
	self assert: targetObject objectId equals: ''.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> flattenedProvenanceWithIdenticalSource [
	<gtExample>
	| storage first second result |
	storage := GtLObjectStorage new.
	first := self
			evaluateProvenanceCode: '1'
			bindings: #()
			in: storage.
	second := self
			evaluateProvenanceCode: '1'
			bindings: #()
			in: storage.
	self
		evaluateProvenanceCode: '99'
		bindings: #()
		in: storage.
	result := self
			evaluateProvenanceCode: 'left + right'
			bindings: {'left' -> first idString36.
					'right' -> second idString36}
			in: storage.
	self
		assert: (GtLProvenanceCodeGenerator new evaluationEntriesFrom: result provenanceTree)
		equals: {first.
				second.
				result}.
	^ result
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> inlinedProvenanceWithReusedBindingName [
	<gtExample>
	| storage firstSeed secondSeed left right result script |
	storage := GtLObjectStorage new.
	firstSeed := storage addNewObject: 10.
	secondSeed := storage addNewObject: 20.
	left := self
			evaluateProvenanceCode: '| subtotal | subtotal := value + 1. value := subtotal + 2. ^ value'
			bindings: {'value' -> firstSeed}
			in: storage.
	right := self
			evaluateProvenanceCode: 'value + 2'
			bindings: {'value' -> secondSeed}
			in: storage.
	result := self
			evaluateProvenanceCode: 'left * 100 + right'
			bindings: {'left' -> left idString36.
					'right' -> right idString36}
			in: storage.
	script := result provenanceScript.
	self
		assert: (script
				includesSubstring: 'subtotal := value + 1. value := subtotal + 2. left := value.').
	self assert: (script includesSubstring: 'right := value + 2.').
	self
		assertReplayOf: script
		in: storage
		equals: result storedValue.
	^ result
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gsCode: '	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			''bindings'' -> #()
			} asDictionary
		inContext: GtLToolExecutionContext new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #(''code'')
		path: #(nil)
		errorMessage: ''required properties missing [code]''.
	^ call'>
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('code')
		path: #(nil)
		errorMessage: 'required properties missing [code]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> storedEvaluationProvenance [
	<gtExample>
	| storage seedId intermediate result root call inputs script |
	storage := GtLObjectStorage new.
	seedId := storage addNewObject: 40.
	intermediate := self
			evaluateProvenanceCode: 'value + 1'
			bindings: {'value' -> seedId}
			in: storage.
	result := self
			evaluateProvenanceCode: 'left + right'
			bindings: {'left' -> intermediate idString36.
					'right' -> intermediate idString36}
			in: storage.

	root := result provenanceTree.
	call := root children first.
	inputs := call children.
	self assert: root target == result.
	self assert: call target == result reason toolCall.
	self assert: (inputs collect: #label) asArray equals: #('left' 'right').
	self assert: (inputs allSatisfy: [ :each | each target == intermediate ]).
	self assert: inputs first children first target == intermediate reason toolCall.
	self
		assert: inputs first children first children first target
				== (storage storedObjectAt: seedId).

	script := result provenanceScript.
	self
		assert: script
		equals: (String cr
				join: {'value := (objectStorage objectAt: ' , seedId storeString , ').'.
						'left := value + 1.'.
						''.
						'right := left.'.
						'left + right'}).
	self
		assertReplayOf: script
		in: storage
		equals: result storedValue.
	^ result
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> storedEvaluationProvenanceAfterClearingStorage [
	<gtExample>
	| storage seedId seed result root inputs missing |
	storage := GtLObjectStorage new.
	seedId := storage addNewObject: 40.
	seed := storage storedObjectAt: seedId.
	result := self
			evaluateProvenanceCode: 'value + 1'
			bindings: {'value' -> seedId}
			in: storage.
	root := result provenanceTree.
	inputs := root children first children.
	storage clearCache.

	self assert: inputs == root children first children.
	self assert: inputs first target == seed.
	self assert: inputs first children isEmpty.
	missing := result provenanceTree children first children first.
	self assert: missing label equals: 'value'.
	self assert: missing target objectId equals: seedId.
	self assert: missing detail equals: 'Unavailable object: ' , seedId.
	self assert: missing children isEmpty.
	^ result
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> storedEvaluationProvenanceWithCycle [
	<gtExample>
	| storage seedId result root cycle |
	storage := GtLObjectStorage new.
	seedId := storage addNewObject: 40.
	result := self
			evaluateProvenanceCode: 'value + 1'
			bindings: {'value' -> seedId}
			in: storage.
	"manually mess up with the object id to create a cycle"
	result reason provenanceBindings first objectId: result idString36.

	root := result provenanceTree.
	cycle := root children first children first.
	self assert: cycle label equals: 'value (cycle)'.
	self assert: cycle target == result.
	self assert: cycle children isEmpty.
	self
		assert: (root gtChildrenFor: GtPhlowView empty) itemsProviderComputation value
				== root children.
	^ root
]
