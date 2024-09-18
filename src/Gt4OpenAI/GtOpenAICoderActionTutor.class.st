Class {
	#name : #GtOpenAICoderActionTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAICoderActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			tutor: self;
			responseFormat: self format asJsonSchema;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> formatName [
	^ 'Smalltalk method'
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionTutor >> gtNewAction [
 	<gtLlmAction>
 	^ GtLlmTutorAction new
 		name: 'New';
 		priority: 1;
 		description: 'Foo';
 		examples: {}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> initialize [
	super initialize.

	self initializePipeline
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmMethodHolder new;
				isImmutableInstance: true ]
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> methodFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Smalltalk method';
		priority: 2;
		format: 'Smalltalk language';
		example: '```
AClass
aMethodWithArguments: anArgument and: anotherArgument
	^ anArgument + anotherArgument
```'
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> performCommandAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Perform command';
		priority: 4;
		description: 'Performs a command provided by the user. May use any properties (text, renames, or method itself) to achieve its goal.';
		format: 'Perform the following command: {1}';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Perform the following command: Reorder the method arguments'.
							'Smalltalk method'
								-> 'ActionClass
findActionIndex: anAction upToIndex: aNumber
	^ (actions first: aNumber) indexOf: anAction
'} asDictionary;
					output: {'Action' -> 'Perform command'.
							'Text' -> nil.
							'Renames' -> nil.
							'Smalltalk method'
								-> 'ActionClass
findUpToIndex: aNumber indexOf: anAction
	^ (actions first: aNumber) indexOf: anAction
'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action'
								-> 'Perform the following command: Write an explanation comment for the method'.
							'Smalltalk method'
								-> 'ClassWithNumber
increment
	self number: self number + 1'} asDictionary;
					output: {'Action' -> 'Perform command'.
							'Text' -> nil.
							'Renames' -> nil.
							'Smalltalk method'
								-> 'ClassWithNumber
increment
	"increments the `number` property of the class"
	self number: self number + 1'} asDictionary}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> refactoringAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose refactoring for method';
		priority: 4;
		description: 'Proposes a refactoring for the method. The method should be rewritten appropriately where necessary while preserving functionality. A textual description of the changes may also be added if deemed necessary.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose refactoring for method'.
							'Smalltalk method'
								-> 'ActionClass
findIndexOfAction: anAction
	^ ((actions
		collectWithIndex: [ :anInnerAction :anIndex | anInnerAction -> anIndex ])
		detect: [ :aPair | aPair key = anAction ]) value'} asDictionary;
					output: {'Action' -> 'Propose refactoring for method'.
							'Renames' -> nil.
							'Text' -> nil.
							'Smalltalk method'
								-> 'ActionClass
findIndexOfAction: anAction
	^ actions indexOf: anAction ifAbsent: [ self error: ''Action not found'' ]'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose refactoring for method'.
							'Smalltalk method'
								-> 'ActionClass
firstAction
	^ actions at: 1'} asDictionary;
					output: {'Action' -> 'Propose refactoring for method'.
							'Renames' -> nil.
							'Text'
								-> 'While the method functions properly as-is, it is usually better to use the explicit collection actions such as `first`, `second`, and `last` instead of relying on indices.'.
							'Smalltalk method'
								-> 'ActionClass
firstAction
	^ actions first'} asDictionary}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for method';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for the method (less than ten, but more than one). The number of method parameters should stay the same across renames, and method that do not take arguments should not have a trailing semicolon (e.g. `helloWorld` instead of `helloWorld:`). Always return the action name, renames, and method.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for method'.
							'Smalltalk method'
								-> 'ActionClass
addAction: anAction
	actions add: anAction
'} asDictionary;
					output: {'Action' -> 'Propose renames for method'.
							'Text' -> nil.
							'Renames'
								-> '{"type": "method", "original": "increment", "proposals": ["extendActions:", "appendAction:", "includeAction:"]}'.
							'Smalltalk method'
								-> 'ActionClass
addAction: anAction
	actions add: anAction
'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for method'.
							'Smalltalk method'
								-> 'ClassWithNumber
increment
	self number: self number + 1'} asDictionary;
					output: {'Action' -> 'Propose renames for method'.
							'Text' -> nil.
							'Renames'
								-> '{"type": "method", "original": "increment", "proposals": ["incrementNumber", "inc", "incNum"]}'.
							'Smalltalk method'
								-> 'ClassWithNumber
increment
	self number: self number + 1'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for method'.
							'Smalltalk method'
								-> 'Object
do: aMessage to: anObject
	^ anObject perform: aMessage'} asDictionary;
					output: {'Action' -> 'Propose renames for method'.
							'Text' -> nil.
							'Renames'
								-> '{"type": "method", "original": "do:to:", "proposals": ["perform:on:", "send:to:", "execute:on:", "exec:on:", "ask:of:"]}'.
							'Smalltalk method'
								-> 'Object
do: aMessage to: anObject
	^ anObject perform: aMessage
'} asDictionary}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Renames';
		priority: 2;
		format: 'json';
		example: 'For methods:
```
{"type": "method", "original": "do:to:", "proposals": ["perform:on:", "send:to:", "execute:on:", "exec:on:", "ask:of:"]}
```

For variables:
```
{"type": "variable", "original": "aNumber", "proposals": ["number", "num", "int", "integer"]}
```'
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameVariableAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for variable';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for a given variable (less than ten, but more than one). Always return the action name, renames, and method.';
		format: 'Propose renames for variable `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for variable `aNumber`'.
							'Smalltalk method'
								-> 'ClassWithNumber
add: aNumber
	self number: self number + aNumber'} asDictionary;
					output: {'Action' -> 'Propose renames for variable'.
							'Text' -> nil.
							'Renames'
								-> '{"type": "variable", "original": "aNumber", "proposals": ["number", "num", "toBeAdded"]}'.
							'Smalltalk method'
								-> 'ClassWithNumber
add: aNumber
	self number: self number + aNumber'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for variable `temp`'.
							'Smalltalk method'
								-> 'ClassWithNumber
add: aNumber
	| temp |
	temp := self number + aNumber
	self number: temp'} asDictionary;
					output: {'Action' -> 'Propose renames for variable'.
							'Text' -> nil.
							'Renames'
								-> '{"type": "variable", "original": "temp", "proposals": ["additionResult", "res", "result"]}'.
							'Smalltalk method'
								-> 'ClassWithNumber
add: aNumber
	| temp |
	temp := self number + aNumber
	self number: temp'} asDictionary}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the method';
		priority: 5;
		description: 'Reviews and criticizes the current state of the method, including code style, like a regular polite yet firm code reviewer would. Code fragments may be returned, and fenced code blocks using three backticks may be used. But if a rewrite is proposed, it will be proposed in the method, not just in the text.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Review the method'.
							'Smalltalk method'
								-> 'ActionObject
foobar: anAction
	actions add: anAction.
	
	anAction isSpecial ifTrue: [
		self notifier exists ifTrue: [
			self notify: (AnActionAdded new action: anAction)]]'} asDictionary;
					output: {'Action' -> 'Review the method'.
							'Renames' -> nil.
							'Text'
								-> 'The method name does not reflect the behavior inside the method. Consider using a name such as `addAction:`.

Furthermore, the two `ifTrue:` calls can be chained together to
`(anAction isSpecial and: [ self notifier exists ]) ifTrue: [ "..." ]`. I took the liberty of adding a rewrite proposal to this review.'.
							'Smalltalk method'
								-> 'ActionObject
foobar: anAction
	actions add: anAction.
	
	(anAction isSpecial and: [ self notifier exists ]) ifTrue:
		[ self notify: (AnActionAdded new action: anAction)]'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Review the method'.
							'Smalltalk method'
								-> 'Integer
isPowerOfTwo
	"Return true if the receiver is an integral power of two."
	^ self ~= 0 and: [(self bitAnd: self-1) = 0]'} asDictionary;
					output: {'Action' -> 'Review the method'.
							'Renames' -> nil.
							'Text'
								-> 'The method name is clear, the method is documented, and the code is concise and well written. No further changes are required.'.
							'Smalltalk method'
								-> 'Integer
isPowerOfTwo
	"Return true if the receiver is an integral power of two."
	^ self ~= 0 and: [(self bitAnd: self-1) = 0]'} asDictionary}
]
