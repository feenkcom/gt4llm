"
I exemplify how ${class:GtWardleyMapEditTool}$ reads the arguments of a tool call.
"
Class {
	#name : #GtWardleyMapEditToolExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #examples }
GtWardleyMapEditToolExamples >> toolCallWithUnknownPage [
	"The arguments of a tool call are read with String keys: a page that is not in the database is reported as such, not as a missing argument"

	<gtExample>
	<return: #GtLFunctionToolCall>
	| aTool aToolCall |
	aTool := GtWardleyMapEditTool new database: LeDatabase new; yourself.
	aToolCall := GtLFunctionToolCall new
			name: aTool name;
			rawArguments: (Dictionary new
					at: 'pageUid' put: UUID new asString36;
					at: 'snippetUid' put: LeUID new uidString;
					at: 'changes' put: #();
					yourself);
			yourself.

	aTool performToolCall: aToolCall inContext: GtLToolExecutionContext new.

	self assert: aToolCall result model class equals: GtLProblemDomainObject.
	self assert: (aToolCall result model description beginsWith: 'Could not locate page').

	^ aToolCall
]
