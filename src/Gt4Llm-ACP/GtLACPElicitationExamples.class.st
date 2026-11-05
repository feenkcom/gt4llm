"
I provide deterministic model and protocol examples for ACP user questions, answers and cancellation. GtLACPElicitationScripterExamples exercises their visual presentation and interaction.
"
Class {
	#name : #GtLACPElicitationExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPElicitationExamples >> cancelledQuestion [
	<gtExample>
	| question replies |
	question := self pendingQuestion.
	question session cancelTurn.
	self assert: question state equals: #cancel.
	replies := question session connection transport sentMessages
			select: [ :each | (each at: 'id' ifAbsent: [ nil ]) = question requestId ].
	self assert: replies size equals: 1.
	self
		assert: (replies first at: 'result')
		equals: {'action' -> 'cancel'} asDictionary.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> closedSessionCancelsQuestion [
	<gtExample>
	| question replies |
	question := self pendingQuestion.
	question session close.
	self assert: question state equals: #cancel.
	replies := question session connection transport sentMessages
			select: [ :each | (each at: 'id' ifAbsent: [ nil ]) = question requestId ].
	self assert: replies size equals: 1.
	question submit.
	self assert: question state equals: #cancel.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> declinedQuestion [
	<gtExample>
	| question |
	question := self pendingQuestion.
	question decline.
	self assert: question state equals: #decline.
	self
		assert: (question session connection transport sentMessages last at: 'result')
		equals: {'action' -> 'decline'} asDictionary.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> disconnectedQuestion [
	<gtExample>
	| question count |
	question := self pendingQuestion.
	count := question session connection transport sentMessages size.
	question session connectionClosed: 'Disconnected'.
	self assert: question state equals: #cancel.
	question submit.
	self
		assert: question session connection transport sentMessages size
		equals: count.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> invalidAnswersStayPending [
	<gtExample>
	| question count |
	question := self pendingQuestion.
	count := question session connection transport sentMessages size.
	question answerAt: 'question_0' put: 'Invented choice'.
	GtLACPExamples new assertRaisesError: [ question submit ] raise: Error.
	self assert: question state equals: #pending.
	self
		assert: question session connection transport sentMessages size
		equals: count.
	question answerAt: 'question_0' put: nil.
	question data
		at: 'requestedSchema'
		put: (question schema copy
				at: 'required' put: #('question_0');
				yourself).
	GtLACPExamples new assertRaisesError: [ question submit ] raise: Error.
	question answerAt: 'question_0' put: 'List'.
	question submit.
	self assert: question state equals: #accept.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> pendingQuestion [
	<gtExample>
	| session turn question |
	session := GtLACPExamples new session.
	turn := session prompt: 'Ask me about the interface.'.
	self
		receive: (self questionParametersFor: session)
		id: 'question-1'
		in: session.
	self assert: turn elicitationRequests size equals: 1.
	question := turn elicitationRequests first.
	self assert: question state equals: #pending.
	self assert: question toolCall == turn toolCalls first.
	self assert: question answers isEmpty.
	self
		assert: ((session connection clientCapabilities at: 'elicitation') includesKey: 'form').
	^ question
]

{ #category : #fixtures }
GtLACPElicitationExamples >> questionParametersFor: aSession [
	^ {'sessionId' -> aSession remoteSessionId.
		'mode' -> 'form'.
		'toolCallId' -> 'ask-1'.
		'message' -> 'How should we build the interface?'.
		'requestedSchema'
			-> {'type' -> 'object'.
					'properties'
						-> {'question_0'
									-> {'type' -> 'string'.
											'title' -> 'Layout'.
											'description' -> 'Choose the main layout.'.
											'oneOf'
												-> {{'const' -> 'List'.
															'title' -> 'List'.
															'description' -> 'A compact list of items.'} asDictionary.
														{'const' -> 'Cards'.
															'title' -> 'Cards'.
															'description' -> 'Cards with room for details.'} asDictionary}}
											asDictionary.
								'question_0_custom'
									-> {'type' -> 'string'.
											'title' -> 'Other'.
											'description' -> 'Your own answer or a note (optional).'}
											asDictionary.
								'question_1'
									-> {'type' -> 'array'.
											'title' -> 'Features'.
											'description' -> 'Select any features you need.'.
											'items'
												-> {'anyOf'
															-> {{'const' -> 'Search'.
																		'title' -> 'Search'} asDictionary.
																	{'const' -> 'Filters'.
																		'title' -> 'Filters'} asDictionary}} asDictionary}
											asDictionary} asOrderedDictionary} asDictionary} asDictionary
]

{ #category : #private }
GtLACPElicitationExamples >> receive: params id: anId in: aSession [
	aSession connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> anId.
				'method' -> 'elicitation/create'.
				'params' -> params} asDictionary
]

{ #category : #examples }
GtLACPElicitationExamples >> remoteCancellation [
	<gtExample>
	| question count |
	question := self pendingQuestion.
	count := question session connection transport sentMessages size.
	question session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'method' -> '$/cancel_request'.
				'params' -> {'requestId' -> question requestId} asDictionary} asDictionary.
	self assert: question state equals: #cancel.
	question submit.
	self
		assert: question session connection transport sentMessages size
		equals: count.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> sessionQuestion [
	<gtExample>
	| question params |
	question := self pendingQuestion.
	params := (self questionParametersFor: question session) copy.
	params removeKey: 'toolCallId'.
	self
		receive: params
		id: 'session-question'
		in: question session.
	self assert: question turn elicitationRequests size equals: 2.
	self assert: question turn elicitationRequests last toolCall isNil.
	^ question turn elicitationRequests last
]

{ #category : #examples }
GtLACPElicitationExamples >> submittedAnswers [
	<gtExample>
	| question reply count |
	question := self pendingQuestion.
	question
		answerAt: 'question_0' put: 'Cards';
		answerAt: 'question_0_custom' put: 'Include a short summary';
		answerAt: 'question_1' put: #('Search' 'Filters').
	question submit.
	reply := question session connection transport sentMessages last.
	self assert: (reply at: 'id') equals: 'question-1'.
	self assert: ((reply at: 'result') at: 'action') equals: 'accept'.
	self assert: ((reply at: 'result') at: 'content') equals: question answers.
	count := question session connection transport sentMessages size.
	question
		submit;
		cancel;
		decline.
	self
		assert: question session connection transport sentMessages size
		equals: count.
	self assert: question state equals: #accept.
	^ question
]

{ #category : #examples }
GtLACPElicitationExamples >> unsupportedForm [
	<gtExample>
	| question params reply |
	question := self pendingQuestion.
	params := (self questionParametersFor: question session) copy
			at: 'mode' put: 'url';
			yourself.
	self
		receive: params
		id: 'unsupported'
		in: question session.
	reply := question session connection transport sentMessages last.
	self assert: ((reply at: 'error') at: 'code') equals: -32602.
	self assert: question turn elicitationRequests size equals: 1.
	^ question
]
