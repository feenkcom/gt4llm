"
I exercise ACP question presentation and interaction through BlScripter. I use GtLACPElicitationExamples for model fixtures.
"
Class {
	#name : #GtLACPElicitationScripterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPElicitationScripterExamples >> childQuestionVisibleInRoot [
	<gtExample>
	| root child question scripter helper modelExamples |
	modelExamples := GtLACPElicitationExamples new.
	root := GtLACPExamples new session.
	root prompt: 'Ask a worker to choose a layout'.
	helper := GtLACPSubagentExamples new.
	child := helper
			announce: 'question-worker'
			title: 'Layout worker'
			in: root.
	helper
		task: 'Choose the layout'
		from: root
		to: child
		id: 'question-task'.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: root;
			element: root asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				notExists ].
	scripter
		doStep: [ :step | 
			step
				block: [ modelExamples
						receive: (modelExamples questionParametersFor: child)
						id: 'child-question'
						in: child ] ].
	scripter pulseUntilReady.
	question := child currentTurn elicitationRequests first.
	self assert: (root currentTurn pendingDelegatedElicitations includes: question).
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-ask-1';
				notExists ].
	scripter click
		id: #'acp-question-question_0-option-1';
		play.
	scripter click
		id: #'acp-question-submit';
		play.
	self assert: question state equals: #accept.
	self assert: root currentTurn pendingDelegatedElicitations isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPElicitationScripterExamples >> freeTextSurvivesRefresh [
	<gtExample>
	| question scripter reply |
	question := GtLACPElicitationExamples new pendingQuestion.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: question;
			element: question session asElement;
			yourself.
	scripter requestFocus
		id: #'acp-question-question_0_custom';
		play.
	scripter typeStep: [ :step | step text: 'Use a timeline instead' ].
	self
		assert: (question answerAt: 'question_0_custom')
		equals: 'Use a timeline instead'.
	scripter doStep: [ :step | step block: [ question session announceChanged ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0_custom';
				value: [ :editor | editor text asString ]
					equals: [ 'Use a timeline instead' ] ].
	scripter click
		id: #'acp-question-submit';
		play.
	reply := question session connection transport sentMessages last.
	self
		assert: (((reply at: 'result') at: 'content') at: 'question_0_custom')
		equals: 'Use a timeline instead'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPElicitationScripterExamples >> pendingQuestionDisplayed [
	<gtExample>
	| question scripter |
	question := GtLACPElicitationExamples new pendingQuestion.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: question;
			element: question session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-ask-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				satisfies: [ :work | 
					| questions |
					questions := OrderedCollection new.
					work
						withAllChildrenBreadthFirstDo: [ :each | (each isKindOf: GtLACPInteractionElement) ifTrue: [ questions add: each ] ].
					questions size = 1 ] ].
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter doStep: [ :step | step block: [ question session announceChanged ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				notExists ].
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPElicitationScripterExamples >> questionDisplayedAndAnswered [
	<gtExample>
	| question scripter |
	question := GtLACPElicitationExamples new pendingQuestion.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: question;
			element: question session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				exists ].
	scripter click
		id: #'acp-question-question_0-option-2';
		play.
	scripter click
		id: #'acp-question-question_1-option-1';
		play.
	scripter click
		id: #'acp-question-question_1-option-2';
		play.
	self assert: (question answerAt: 'question_0') equals: 'Cards'.
	self assert: (question answerAt: 'question_1') equals: #('Search' 'Filters').
	scripter doStep: [ :step | step block: [ question session announceChanged ] ].
	scripter pulseUntilReady.
	self assert: (question answerAt: 'question_0') equals: 'Cards'.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-option-2';
				satisfies: [ :button | button isChecked ] ].
	scripter click
		id: #'acp-question-submit';
		play.
	scripter pulseUntilReady.
	self assert: question state equals: #accept.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-ask-1';
				notExists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPElicitationScripterExamples >> sessionQuestionDisplayedInWork [
	<gtExample>
	| session examples params scripter |
	examples := GtLACPElicitationExamples new.
	session := GtLACPExamples new session.
	session prompt: 'Ask a question without a tool call'.
	params := examples questionParametersFor: session.
	params removeKey: 'toolCallId'.
	examples
		receive: params
		id: 'session-question'
		in: session.
	self assert: session currentTurn toolCalls isEmpty.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: session;
			element: session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				exists ].
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-submit';
				notExists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPElicitationScripterExamples >> singleChoiceUsesRadioGroup [
	<gtExample>
	| scripter question |
	scripter := self pendingQuestionDisplayed.
	question := scripter model.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-choices';
				satisfies: [ :group | group isKindOf: BrRadioButtonGroup ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-option-1';
				satisfies: [ :radio | (radio isKindOf: BrRadioButton) and: [ radio isUnchecked ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_1-option-1';
				satisfies: [ :checkbox | checkbox isKindOf: BrCheckbox ] ].
	scripter clickStep: [ :step | step id: #'acp-question-question_0-option-1' ].
	self assert: (question answerAt: 'question_0') equals: 'List'.
	scripter clickStep: [ :step | step id: #'acp-question-question_0-option-2' ].
	self assert: (question answerAt: 'question_0') equals: 'Cards'.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-option-1';
				satisfies: #isUnchecked ].
	scripter clickStep: [ :step | step id: #'acp-question-question_0-option-2' ].
	self assert: (question answerAt: 'question_0') equals: 'Cards'.
	scripter
		clickStep: [ :step | step id: #'acp-question-question_0-option-text-1' ].
	self assert: (question answerAt: 'question_0') equals: 'List'.
	scripter doStep: [ :step | step block: [ question session announceChanged ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-option-1';
				satisfies: #isChecked ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-question-question_0-option-2';
				satisfies: #isUnchecked ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
