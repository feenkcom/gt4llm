Class {
	#name : #GtOpenAICoderActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

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
aMethodWithArguments: anArgument and: anotherArgument
	^ anArgument + anotherArgument
```'
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for method';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for the method (less than ten, but more than one).';
		format: 'Propose renames for method `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Propose renames for method `addAction:`';
					input: '```smalltalk-method
addAction: anAction
	actions add: anAction
```';
					output: '```action
Propose renames for method
```
```renames
extendActions:
appendAction:
includeAction:
```'.
GtLlmTutorActionExample new
					instruction: 'Propose renames for method `increment`';
					input: '```smalltalk-method
increment
	self number: self number + 1
```';
					output: '```action
Propose renames for method
```
```renames
incrementNumber
inc
incNum
```'.
GtLlmTutorActionExample new
					instruction: 'Propose renames for method `do:to:`';
					input: '```smalltalk-method
do: aMessage to: anObject
	^ anObject perform: aMessage
```';
					output: '```action
Propose renames for method
```
```renames
perform:on:
send:to:
execute:on:
exec:on:
ask:of:
```'}
]

{ #category : #accessing }
GtOpenAICoderActionTutor >> renameFormatComponent [
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

{ #category : #accessing }
GtOpenAICoderActionTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the method';
		priority: 5;
		description: 'Reviews and criticizes the current state of the method, including code style, like a regular polite yet firm code reviewer would.';
		examples: {GtLlmTutorActionExample new
					instruction: 'Review the method';
					input: '```foobar: anAction
	actions add: anAction.
	
	anAction isSpecial ifTrue: [
		self notifier exists ifTrue: [
			self notify: (AnActionAdded new action: anAction)]]
```';
					output: '```text
The method name does not reflect the behavior inside the method. Consider using a name such as `addAction:`.

Furthermore, the two `ifTrue:` calls can be chained together. I suggest rewriting it as follows:

	(anAction isSpecial and: [ self notifier exists ]) ifTrue: [
		self notify: (AnActionAdded new action: anAction)]]
```'}
]
