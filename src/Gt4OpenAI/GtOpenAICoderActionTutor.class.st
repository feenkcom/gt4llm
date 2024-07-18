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
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> formatName [
	^ 'Smalltalk method'
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
		tag: 'smalltalk-method';
		example: '```smalltalk-method
AClass
aMethodWithArguments: anArgument and: anotherArgument
	^ anArgument + anotherArgument
```'
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> refactoringAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose refactoring for method';
		priority: 4;
		description: 'Proposes a refactoring for the method. The method should be rewritten appropriately where necessary while preserving functionality.';
		format: 'Propose refactoring for method';
		examples: {GtLlmTutorActionExample new
					instruction: 'Propose refactoring for method';
					input: '```smalltalk-method
ActionClass
findIndexOfAction: anAction
	^ ((actions
		collectWithIndex: [ :anInnerAction :anIndex | anInnerAction -> anIndex ])
		detect: [ :aPair | aPair key = anAction ]) value
```';
					output: '```action
Propose refactoring for method
```
```smalltalk-method
ActionClass
addAction: anAction
	^ actions indexOf: anAction ifAbsent: [ self error: ''Action not found'' ]
```'}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for method';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for the method (less than ten, but more than one). The number of method parameters should stay the same across renames, and method that do not take arguments should not have a trailing semicolon (e.g. `helloWorld` instead of `helloWorld:`). Always return the action name, renames, and method.';
		format: 'Propose renames for method';
		examples: {GtLlmTutorActionExample new
					instruction: 'Propose renames for method';
					input: '```smalltalk-method
ActionClass
addAction: anAction
	actions add: anAction
```';
					output: '```action
Propose renames for method
```
```renames
{"type": "method", "original": "increment", "proposals": ["extendActions:", "appendAction:", "includeAction:"]}
```
```smalltalk-method
ActionClass
addAction: anAction
	actions add: anAction
```'.
GtLlmTutorActionExample new
					instruction: 'Propose renames for method';
					input: '```smalltalk-method
ClassWithNumber
increment
	self number: self number + 1
```';
					output: '```action
Propose renames for method
```
```renames
{"type": "method", "original": "increment", "proposals": ["incrementNumber", "inc", "incNum"]}
```
```smalltalk-method
ClassWithNumber
increment
	self number: self number + 1
```'.
GtLlmTutorActionExample new
					instruction: 'Propose renames for method';
					input: '```smalltalk-method
Object
do: aMessage to: anObject
	^ anObject perform: aMessage
```';
					output: '```action
Propose renames for method
```
```renames
{"type": "method", "original": "do:to:", "proposals": ["perform:on:", "send:to:", "execute:on:", "exec:on:", "ask:of:"]}
```
```smalltalk-method
Object
do: aMessage to: anObject
	^ anObject perform: aMessage
```'}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Renames';
		priority: 2;
		format: 'json';
		tag: 'renames';
		example: 'For methods:
```renames
{"type": "method", "original": "do:to:", "proposals": ["perform:on:", "send:to:", "execute:on:", "exec:on:", "ask:of:"]}
```

For variables:
```renames
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
		format: 'Propose renames for variable ``';
		examples: {GtLlmTutorActionExample new
					instruction: 'Propose renames for variable `aNumber`';
					input: '```smalltalk-method
ClassWithNumber
add: aNumber
	self number: self number + aNumber
```';
					output: '```action
Propose renames for variable
```
```renames
{"type": "variable", "original": "aNumber", "proposals": ["number", "num", "toBeAdded"]}
```
```smalltalk-method
ClassWithNumber
add: aNumber
	self number: self number + aNumber
```'.
GtLlmTutorActionExample new
					instruction: 'Propose renames for variable `temp`';
					input: '```smalltalk-method
ClassWithNumber
add: aNumber
	| temp |
	temp := self number + aNumber
	self number: temp
```';
					output: '```action
Propose renames for variable
```
```renames
{"type": "variable", "original": "temp", "proposals": ["additionResult", "res", "result"]}
```
```smalltalk-method
ClassWithNumber
add: aNumber
	| temp |
	temp := self number + aNumber
	self number: temp
```'}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the method';
		priority: 5;
		description: 'Reviews and criticizes the current state of the method, including code style, like a regular polite yet firm code reviewer would.';
		examples: {GtLlmTutorActionExample new
					instruction: 'Review the method';
					input: '```ActionObject
foobar: anAction
	actions add: anAction.
	
	anAction isSpecial ifTrue: [
		self notifier exists ifTrue: [
			self notify: (AnActionAdded new action: anAction)]]
```';
					output: '```action
Review the method
```
```text
The method name does not reflect the behavior inside the method. Consider using a name such as `addAction:`.

Furthermore, the two `ifTrue:` calls can be chained together. I suggest rewriting it as follows:

	(anAction isSpecial and: [ self notifier exists ]) ifTrue: [
		self notify: (AnActionAdded new action: anAction)]]
```'}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> textFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Text';
		priority: 2;
		format: 'Text';
		tag: 'text';
		example: '```text
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted.

# Headings exist as well
```'
]
