"
Examples of focused tool call inspector views.
"
Class {
	#name : #GtLACPToolCallExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPToolCallExamples >> bashCodeAndOutput [
	<gtExample>
	| call report output element |
	call := self bashView.
	report := call bashReport.
	output := 'hello' , String lf , 'second line' , String lf.
	call
		updateFrom: (Dictionary new
				at: 'rawOutput' put: output;
				yourself).
	self assert: report outputText equals: output.
	self
		assert: (report gtOutputFor: GtPhlowView empty) textBuilder value
		equals: output.
	element := (report gtCodeAndOutputFor: GtPhlowView empty) asElement.
	self assert: (element userData includesKey: #exception) not.
	self assert: element children size equals: 2.
	self
		assert: report source
		equals: '# Print a greeting' , String lf , String lf , 'printf ''hello\n'''.
	^ report
]

{ #category : #examples }
GtLACPToolCallExamples >> bashMultilineDescription [
	<gtExample>
	| call command |
	call := self bashView.
	command := 'printf ''one\ntwo\n''' , String lf , 'printf ''done\n'''.
	(call data at: 'rawInput')
		at: 'description' put: 'First line' , String crlf , 'Second line';
		at: 'command' put: command.
	self
		assert: call bashReport source
		equals: '# First line' , String lf , '# Second line' , String lf , String lf , command.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> bashOutputFallback [
	<gtExample>
	| call report content |
	call := self bashView.
	report := call bashReport.
	self assert: report outputText equals: ''.
	content := {Dictionary new
				at: 'type' put: 'text';
				at: 'text' put: 'hello';
				yourself}.
	call data at: 'content' put: content.
	self assert: (STONJSON fromString: report outputText) equals: content.
	call data at: 'rawOutput' put: ''.
	self assert: report outputText equals: ''.
	^ report
]

{ #category : #examples }
GtLACPToolCallExamples >> bashView [
	<gtExample>
	| call report coder view element |
	call := GtLACPToolCall new
			data: (Dictionary new
					at: 'name' put: 'Bash';
					at: 'rawInput'
						put: (Dictionary new
								at: 'command' put: 'printf ''hello\n''';
								at: 'description' put: 'Print a greeting';
								yourself);
					yourself);
			yourself.
	report := call bashReport.
	self assert: report toolCall == call.
	self
		assert: report source
		equals: '# Print a greeting' , String lf , String lf , 'printf ''hello\n'''.
	view := call gtBashFor: GtPhlowView empty.
	self assert: (view isKindOf: GtPhlowForwarderView).
	self assert: view title equals: 'Bash'.
	coder := report shellCoder.
	self assert: (coder isKindOf: GtShellScriptSourceCoder).
	self assert: coder currentSourceString equals: report source.
	self assert: coder pharoBindings notNil.
	element := view asElement.
	self assert: (element userData includesKey: #exception) not.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> bashViewUnavailable [
	<gtExample>
	| call |
	call := GtLACPToolCall new
			data: Dictionary new;
			yourself.
	self assert: call bashCommand isNil.
	self assert: ((call gtBashFor: GtPhlowView empty) isKindOf: GtPhlowEmptyView).
	call data
		at: 'name' put: 'Bash';
		at: 'rawInput' put: 'partial'.
	self assert: call bashCommand isNil.
	call data
		at: 'rawInput'
		put: (Dictionary new
				at: 'command' put: 42;
				yourself).
	self assert: call bashCommand isNil.
	call data at: 'name' put: 'Read'.
	(call data at: 'rawInput') at: 'command' put: 'echo no'.
	self assert: call bashCommand isNil.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> bashWithoutDescription [
	<gtExample>
	| call |
	call := self bashView.
	(call data at: 'rawInput') removeKey: 'description'.
	self assert: call bashReport source equals: call bashCommand.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> inputView [
	<gtExample>
	| call input view |
	input := Dictionary new
			at: 'query' put: 'example';
			yourself.
	call := GtLACPToolCall new
			data: (Dictionary new
					at: 'rawInput' put: input;
					yourself);
			yourself.
	view := call gtInputFor: GtPhlowView empty.
	self assert: view title equals: 'Input'.
	self assert: (STONJSON fromString: view textBuilder value) equals: input.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> inputViewWithoutInput [
	<gtExample>
	| call view |
	call := GtLACPToolCall new
			data: Dictionary new;
			yourself.
	view := call gtInputFor: GtPhlowView empty.
	self assert: view textBuilder value equals: (STONJSON toStringPretty: nil).
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> outputViewFallback [
	<gtExample>
	| call view content |
	call := GtLACPToolCall new
			data: Dictionary new;
			yourself.
	view := call gtOutputFor: GtPhlowView empty.
	self assert: view textBuilder value equals: (STONJSON toStringPretty: nil).
	call data at: 'content' put: 'fallback text'.
	self assert: view textBuilder value equals: 'fallback text'.
	content := {Dictionary new
				at: 'type' put: 'text';
				at: 'text' put: 'hello';
				yourself}.
	call data at: 'content' put: content.
	self assert: view textBuilder value equals: (STONJSON toStringPretty: content).
	call data at: 'rawOutput' put: ''.
	self assert: view textBuilder value equals: ''.
	call data at: 'rawOutput' put: nil.
	self assert: view textBuilder value equals: (STONJSON toStringPretty: nil).
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> outputViewWithString [
	<gtExample>
	| call output view |
	output := '{' , String lf , String tab , '"code": "s contents",' , String lf
			, String tab , '"errorDetails": {"stackTrace": "first\nsecond"}' , String lf
			, '}'.
	call := GtLACPToolCall new
			data: (Dictionary new
					at: 'rawOutput' put: output;
					yourself);
			yourself.
	view := call gtOutputFor: GtPhlowView empty.
	self assert: view textBuilder value equals: output.
	call data at: 'rawOutput' put: 'plain text, not JSON'.
	self assert: view textBuilder value equals: 'plain text, not JSON'.
	call data at: 'rawOutput' put: ''.
	self assert: view textBuilder value equals: ''.
	call data at: 'rawOutput' put: output.
	^ call
]

{ #category : #examples }
GtLACPToolCallExamples >> outputViewWithStructuredOutput [
	<gtExample>
	| call output view |
	output := Dictionary new
			at: 'message' put: 'hello';
			at: 'count' put: 2;
			yourself.
	call := GtLACPToolCall new
			data: (Dictionary new
					at: 'rawOutput' put: output;
					yourself);
			yourself.
	view := call gtOutputFor: GtPhlowView empty.
	self assert: view textBuilder value equals: (STONJSON toStringPretty: output).
	^ call
]
