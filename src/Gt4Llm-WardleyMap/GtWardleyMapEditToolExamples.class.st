"
I exemplify how ${class:GtWardleyMapEditTool}$ reads the arguments of a tool call.
"
Class {
	#name : #GtWardleyMapEditToolExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #examples }
GtWardleyMapEditToolExamples >> toolCallWithDashedAndInvalidPageUids [
	"The page id can be given in the dashed form of its UUID: a page that is not in the database is then reported as not found. Text that is no page id is refused as invalid"

	<gtExample>
	| aTool resultFor |
	aTool := GtWardleyMapEditTool new
			database: LeDatabase new;
			yourself.
	resultFor := [ :aPageUid | 
		| aToolCall |
		aToolCall := GtLFunctionToolCall new
				name: aTool name;
				rawArguments: (Dictionary new
						at: 'pageUid' put: aPageUid;
						at: 'snippetUid' put: LeUID new uidString;
						at: 'changes' put: #();
						yourself);
				yourself.
		aTool performToolCall: aToolCall inContext: GtLToolExecutionContext new.
		aToolCall result model ].
	self
		assert: ((resultFor value: UUID new asString) description
				beginsWith: 'Could not locate page').
	self
		assert: ((resultFor value: 'not base 36!') errorMessage
				includesSubstring: 'Invalid page uid').
	^ aTool
]

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
