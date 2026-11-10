"
I exercise the session configuration expander and its Magritte form, including Codex and Claude values, grouped choices, missing information, expansion, live updates, user selections, dependent effort choices, boolean values and rejected configuration requests.
"
Class {
	#name : #GtLACPSessionConfigurationExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSessionConfigurationExamples >> acceptAppliesChangedFields [
	<gtExample>
	| options session scripter requests |
	requests := OrderedCollection new.
	options := self codexOptions deepCopy.
	options third
		at: 'options'
		put: {self choice: 'ask' named: 'Ask'.
				self choice: 'code' named: 'Code'}.
	session := self
			sessionWithOptions: options
			updating: [ :currentOptions :params | 
				requests add: (params at: 'configId').
				(currentOptions
					detect: [ :each | (each at: 'id') = (params at: 'configId') ])
					at: 'currentValue'
					put: (params at: 'value').
				currentOptions ].
	scripter := self scripterForSession: session.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		choose: 'Low'
		option: 'reasoning_effort'
		in: scripter.
	self
		choose: 'Code'
		option: 'mode'
		in: scripter.
	self assert: requests isEmpty.
	self acceptIn: scripter.
	self assert: requests asArray equals: #('reasoning_effort' 'mode').
	self
		assertFormValue: 'Low'
		option: 'reasoning_effort'
		in: scripter.
	self
		assertFormValue: 'Code'
		option: 'mode'
		in: scripter.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		assertText: 'Low'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> acceptIn: scripter [
	scripter
		clickStep: [ :step | 
			step
				id: (GtMagritteActionElementId new
						description: GtLACPSessionConfigurationForm new magritteAcceptAction) ].
	scripter pulseUntilReady
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> assertFormValue: text option: anId in: scripter [
	self
		assertText: text
		id: (self fieldId: anId in: scripter)
		in: scripter
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> assertNoRenderingErrorsIn: scripter [
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> assertText: aString id: anId in: scripter [
	scripter
		assertStep: [ :step | 
			step
				id: anId;
				value: [ :label | label text asString ] equals: [ aString ] ]
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> cancelDiscardsPendingChanges [
	<gtExample>
	| scripter session |
	scripter := self sessionToolExpanded.
	session := scripter model.
	self
		choose: 'Low'
		option: 'reasoning_effort'
		in: scripter.
	self assert: (session configOptions second at: 'currentValue') equals: 'high'.
	self cancelIn: scripter.
	self
		assertFormValue: 'High'
		option: 'reasoning_effort'
		in: scripter.
	self assert: (session configOptions second at: 'currentValue') equals: 'high'.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-configuration';
				satisfies: [ :element | element isCollapsed ] ].
	self
		assertText: 'High'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> cancelIn: scripter [
	scripter
		clickStep: [ :step | 
			step
				id: (GtMagritteActionElementId new
						description: GtLACPSessionConfigurationForm new magritteCancelAction) ].
	scripter pulseUntilReady
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> changeBooleanThroughForm [
	<gtExample>
	| options session scripter fieldId |
	options := {{'id' -> 'enabled'.
				'name' -> 'Enabled'.
				'type' -> 'boolean'.
				'currentValue' -> false} asDictionary}.
	session := self
			sessionWithOptions: options
			updating: [ :currentOptions :params | 
				self assert: (params at: 'type') equals: 'boolean'.
				currentOptions first at: 'currentValue' put: (params at: 'value').
				currentOptions ].
	scripter := self scripterForSession: session.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	fieldId := self fieldId: 'enabled' in: scripter.
	scripter
		clickStep: [ :step | 
			step
				// fieldId;
				/ BrCheckbox ].
	self acceptIn: scripter.
	scripter
		assertStep: [ :step | 
			step
				onModel;
				value: [ :model | model configOptions first at: 'currentValue' ]
					equals: [ true ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> changeModelRefreshesEffortChoices [
	<gtExample>
	| options session scripter fieldId |
	options := self codexOptions deepCopy.
	(options first at: 'options') first
		at: 'options'
		put: {self choice: 'codex-test' named: 'Codex Test Model'.
				self choice: 'other-model' named: 'Other Model'}.
	session := self
			sessionWithOptions: options
			updating: [ :currentOptions :params | 
				self assert: (params at: 'configId') equals: 'model'.
				currentOptions first at: 'currentValue' put: (params at: 'value').
				currentOptions second
					at: 'currentValue' put: 'medium';
					at: 'options' put: {self choice: 'medium' named: 'Medium'}.
				currentOptions ].
	scripter := self scripterForSession: session.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		choose: 'Other Model'
		option: 'model'
		in: scripter.
	self assert: (session configOptions second at: 'currentValue') equals: 'high'.
	self acceptIn: scripter.
	self
		assertFormValue: 'Other Model'
		option: 'model'
		in: scripter.
	self
		assertFormValue: 'Medium'
		option: 'reasoning_effort'
		in: scripter.
	fieldId := self fieldId: 'reasoning_effort' in: scripter.
	self assert: fieldId description options equals: #('medium').
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-configuration';
				satisfies: [ :element | element isExpanded ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #fixtures }
GtLACPSessionConfigurationExamples >> choice: aValue named: aName [
	^ {'value' -> aValue.
		'name' -> aName} asDictionary
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> choose: label option: anId in: scripter [
	| fieldId |
	fieldId := self fieldId: anId in: scripter.
	scripter clickStep: [ :step | step id: fieldId ].
	scripter
		clickStep: [ :step | 
			step
				onSpaceRoot;
				onChildFromBlock: [ :root | 
					(root
						allChildrenBreadthFirstSelect: [ :each | (each isKindOf: BrLabel) and: [ each text asString = label ] ])
						last ] ].
	scripter pulseUntilReady
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> claudeCollapsed [
	<gtExample>
	| scripter |
	scripter := self scripterForOptions: self claudeOptions.
	self
		assertText: 'Claude Test Model'
		id: #'acp-configuration-model'
		in: scripter.
	self
		assertText: 'Medium'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #fixtures }
GtLACPSessionConfigurationExamples >> claudeOptions [
	^ {self
			option: 'model'
			name: 'Model'
			category: 'model'
			value: 'claude-test'
			choices: {self choice: 'claude-test' named: 'Claude Test Model'}.
		self
			option: 'effort'
			name: 'Effort'
			category: 'thought_level'
			value: 'medium'
			choices: {self choice: 'medium' named: 'Medium'}}
]

{ #category : #fixtures }
GtLACPSessionConfigurationExamples >> codexOptions [
	^ {self
			option: 'model'
			name: 'Model'
			category: 'model'
			value: 'codex-test'
			choices: {{'group' -> 'recommended'.
						'name' -> 'Recommended'.
						'options' -> {self choice: 'codex-test' named: 'Codex Test Model'}}
						asDictionary}.
		self
			option: 'reasoning_effort'
			name: 'Reasoning Effort'
			category: 'thought_level'
			value: 'high'
			choices: {self choice: 'high' named: 'High'.
					self choice: 'low' named: 'Low'}.
		self
			option: 'mode'
			name: 'Approval Preset'
			category: 'mode'
			value: 'ask'
			choices: {self choice: 'ask' named: 'Ask'}}
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> fieldId: anId in: scripter [
	| fieldId |
	scripter
		assertStep: [ :step | 
			step
				satisfies: [ :root | 
					root
						withAllChildrenBreadthFirstDo: [ :each | 
							((each id isKindOf: GtMagritteFieldElementId)
								and: [ (each id description propertyAt: #acpConfigId ifAbsent: [ nil ]) = anId ])
								ifTrue: [ fieldId := each id ] ].
					fieldId notNil ] ].
	^ fieldId
]

{ #category : #fixtures }
GtLACPSessionConfigurationExamples >> option: anId name: aName category: aCategory value: aValue choices: choices [
	^ {'id' -> anId.
		'name' -> aName.
		'category' -> aCategory.
		'type' -> 'select'.
		'currentValue' -> aValue.
		'options' -> choices} asDictionary
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> rejectedChangeIsReported [
	<gtExample>
	| transport defaultResponder client session scripter |
	transport := GtLACPExamples new transport.
	defaultResponder := transport responder.
	transport
		responder: [ :message :aTransport | 
			(message at: 'method' ifAbsent: [ '' ]) = 'session/set_config_option'
				ifTrue: [ aTransport
						receive: {'jsonrpc' -> '2.0'.
								'id' -> (message at: 'id').
								'error'
									-> {'code' -> -32602.
											'message' -> 'Effort change rejected'} asDictionary} asDictionary ]
				ifFalse: [ defaultResponder value: message value: aTransport ] ].
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	session configOptions: self codexOptions.
	scripter := self scripterForSession: session.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		choose: 'Low'
		option: 'reasoning_effort'
		in: scripter.
	self assert: (session configOptions second at: 'currentValue') equals: 'high'.
	self acceptIn: scripter.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-configuration-form';
				satisfies: [ :element | 
					(element userData at: GtMagritteViewModel gtMementoSymbol) executionStatus
						valueOrNil isKindOf: GtMagritteExecutionExceptionStatus ] ].
	self assert: (session configOptions second at: 'currentValue') equals: 'high'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> scripterForOptions: options [
	^ BlScripter new
		extent: 800 @ 300;
		element: (GtLACPSessionConfigurationElement new
				configOptions: options;
				yourself);
		yourself
]

{ #category : #private }
GtLACPSessionConfigurationExamples >> scripterForSession: session [
	^ BlScripter new
		extent: 1100 @ 800;
		model: session;
		element: ((GtLACPSessionTool forSession: session) asElementDo: [ :widget | widget ]);
		yourself
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> sessionTool [
	<gtExample>
	| session scripter |
	session := GtLACPExamples new session.
	session configOptions: self codexOptions.
	scripter := self scripterForSession: session.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-configuration';
				satisfies: [ :element | element isCollapsed ] ].
	self
		assertText: 'Codex Test Model'
		id: #'acp-configuration-model'
		in: scripter.
	self
		assertText: 'High'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> sessionToolExpanded [
	<gtExample>
	| scripter |
	scripter := self sessionTool.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		assertFormValue: 'High'
		option: 'reasoning_effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> sessionToolFollowsConfigurationUpdate [
	<gtExample>
	| scripter options |
	scripter := self sessionToolExpanded.
	options := self codexOptions deepCopy.
	options second at: 'currentValue' put: 'low'.
	scripter
		doStep: [ :step | 
			step
				block: [ scripter model
						receiveUpdate: {'sessionUpdate' -> 'config_option_update'.
								'configOptions' -> options} asDictionary ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-configuration';
				satisfies: [ :element | element isExpanded ] ].
	self
		assertFormValue: 'Low'
		option: 'reasoning_effort'
		in: scripter.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self
		assertText: 'Low'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #fixtures }
GtLACPSessionConfigurationExamples >> sessionWithOptions: initialOptions updating: aBlock [
	| transport defaultResponder options client session |
	options := initialOptions.
	transport := GtLACPExamples new transport.
	defaultResponder := transport responder.
	transport
		responder: [ :message :aTransport | 
			(message at: 'method' ifAbsent: [ '' ]) = 'session/set_config_option'
				ifTrue: [ options := aBlock value: options deepCopy value: (message at: 'params').
					aTransport
						replyTo: message
						result: {'configOptions' -> options} asDictionary ]
				ifFalse: [ defaultResponder value: message value: aTransport ] ].
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	session configOptions: options.
	^ session
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> unavailableOptions [
	<gtExample>
	| scripter |
	scripter := self scripterForOptions: #().
	self
		assertText: 'Not advertised'
		id: #'acp-configuration-model'
		in: scripter.
	self
		assertText: 'Not advertised'
		id: #'acp-configuration-effort'
		in: scripter.
	scripter clickStep: [ :step | step id: GtSourceCoderExpanderToggleId ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionConfigurationExamples >> unknownValueAndMissingCategory [
	<gtExample>
	| options scripter |
	options := self claudeOptions deepCopy.
	options first
		at: 'currentValue' put: 'unlisted-model';
		removeKey: 'category'.
	options second removeKey: 'category'.
	scripter := self scripterForOptions: options.
	self
		assertText: 'unlisted-model'
		id: #'acp-configuration-model'
		in: scripter.
	self
		assertText: 'Medium'
		id: #'acp-configuration-effort'
		in: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]
