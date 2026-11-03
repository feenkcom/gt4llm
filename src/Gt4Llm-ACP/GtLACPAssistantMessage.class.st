"
I represent the assistant response to one prompt. I expose ordered tools, reasoning and commentary separately from the final reply. The prompt turn owns execution and protocol state.
"
Class {
	#name : #GtLACPAssistantMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPAssistantMessage >> activityItems [
 ^ self localActivityItems, (self delegatedMessages flatCollect: #activityItems)
]

{ #category : #converting }
GtLACPAssistantMessage >> asElement [
 ^ (GtLACPChatMessageViewModel new turn: turn; message: self; yourself) asElement
]

{ #category : #converting }
GtLACPAssistantMessage >> chatElementClass [
 ^ GtLACPAssistantMessageElement
]

{ #category : #accessing }
GtLACPAssistantMessage >> chatLabel [
 ^ turn session isSubagent
  ifTrue: [ turn session conversationTitle ]
  ifFalse: [ turn session client displayName ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> delegatedMessages [
 ^ turn delegatedTurns collect: #assistantMessage
]

{ #category : #accessing }
GtLACPAssistantMessage >> finalMessages [
 ^ turn finalMessage ifNil: [ #() ] ifNotNil: [ :message | { message } ]
]

{ #category : #views }
GtLACPAssistantMessage >> finalReplyViewsInContext: aContext [
 | views |
 views := (GtPhlowViewsCollector new
  fromObject: self;
  pragmaNames: GtLSettings messageViewPragmaNames;
  context: aContext;
  collect),
  (turn session summarizerViewsFor: self relevantToolCallsSummarizers inContext: aContext).
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #views }
GtLACPAssistantMessage >> gtFinalReplyFor: aView inContext: aPhlowContext [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Markdown';
		priority: 5;
		stencil: [ | text styler |
			text := self text asRopedText.
			styler := GtLMessageStyler new
					objectRegistry: aPhlowContext objectRegistry;
					yourself.
			styler privateStyle: text.
			BrEditor new
				id: #'acp-final-text';
				aptitude: BrGlamorousRegularEditorAptitude;
				beReadOnlyWithSelection;
				hMatchParent;
				vFitContentLimited;
				text: text;
				yourself ]
]

{ #category : #views }
GtLACPAssistantMessage >> gtOutcomeFor: aView [
 <gtView>
 ^ aView forward title: 'Outcome'; priority: 10; object: [ turn ]; view: #gtOutcomeFor:
]

{ #category : #views }
GtLACPAssistantMessage >> gtToolsFor: aView [
 <gtView>
 ^ aView list title: 'Tool calls'; priority: 15; items: [ self toolCalls ]; itemText: #title
]

{ #category : #views }
GtLACPAssistantMessage >> gtViewsInContext: aContext [
 | views |
 aContext objectRegistry: turn session objectStorage.
 views := (super gtViewsInContext: aContext),
  (turn session summarizerViewsFor: self relevantToolCallsSummarizers inContext: aContext).
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #views }
GtLACPAssistantMessage >> gtWorkFor: aView [
 <gtView>
 ^ aView list title: 'Tools and reasoning'; priority: 0;
  items: [ self activityItems ];
  itemText: [ :item | (item isKindOf: GtLACPToolCall)
   ifTrue: [ item title, ' · ', item status ]
   ifFalse: [ item text ] ];
  actionUpdateButtonTooltip: 'Refresh tools and reasoning'
]

{ #category : #views }
GtLACPAssistantMessage >> gtWorkSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Work summary';
		priority: 5;
		items: [ {'Agents' -> turn allDelegatedSessions asArray.
				'Tools' -> self toolCalls.
				'Latest activity' -> self latestWorkItem.
				'Summary' -> self workSummary} ];
		column: 'Field' text: #key;
		column: 'Value' text: [ :entry | entry value gtDisplayString ];
		send: #value;
		actionUpdateButtonTooltip: 'Refresh work summary'
]

{ #category : #testing }
GtLACPAssistantMessage >> hasCompletedReply [
 ^ (#(completed replayed idle) includes: turn state) and: [ self finalMessages notEmpty ]
]

{ #category : #testing }
GtLACPAssistantMessage >> hasWork [
 ^ self localActivityItems notEmpty or: [ self delegatedMessages notEmpty ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> latestWorkItem [
 | items eligible |
 items := self activityItems.
 eligible := items asIdentitySet.
 eligible addAll: turn allDelegatedSessions.
 ^ turn workUpdates reversed detect: [ :item | eligible includes: item ]
  ifNone: [
   items ifEmpty: [
    self delegatedMessages ifEmpty: [ nil ] ifNotEmpty: [ :messages | messages last turn session ] ]
   ifNotEmpty: [ items last ] ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> localActivityItems [
 ^ turn workActivity
]

{ #category : #summaries }
GtLACPAssistantMessage >> mcpToolMessages [
 ^ turn session mcpToolMessagesFor: self toolCalls
]

{ #category : #accessing }
GtLACPAssistantMessage >> messages [
 turn activity.
 ^ turn messages copy reject: [ :each | each role = #user ]
]

{ #category : #printing }
GtLACPAssistantMessage >> printOn: aStream [
 aStream nextPutAll: 'Assistant response ('; nextPutAll: self state asString; nextPutAll: ')'
]

{ #category : #summaries }
GtLACPAssistantMessage >> relevantToolCallsSummarizers [
 ^ self toolCallsSummarizers select: #isRelevant
]

{ #category : #accessing }
GtLACPAssistantMessage >> role [
 ^ #assistant
]

{ #category : #accessing }
GtLACPAssistantMessage >> state [
 ^ turn state
]

{ #category : #accessing }
GtLACPAssistantMessage >> text [
 ^ String streamContents: [ :stream | self finalMessages do: [ :each | stream nextPutAll: each text ] ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> toolCalls [
 ^ turn allToolCalls
]

{ #category : #summaries }
GtLACPAssistantMessage >> toolCallsSummarizers [
 ^ turn session summarizersRegistry summarizersForMessages: self mcpToolMessages
]

{ #category : #accessing }
GtLACPAssistantMessage >> turn [
 ^ turn
]

{ #category : #accessing }
GtLACPAssistantMessage >> turn: anObject [
 turn := anObject
]

{ #category : #accessing }
GtLACPAssistantMessage >> workSummary [
	| parts details |
	parts := self workSummaryCountLabels.
	details := self workSummaryDetails.
	details ifNotEmpty: [ parts add: details ].
	^ String
		streamContents: [ :stream | 
			parts
				do: [ :part | stream nextPutAll: part ]
				separatedBy: [ stream nextPutAll: ' · ' ] ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> workSummaryCountLabels [
	| labels agentCount toolCount |
	labels := OrderedCollection new.
	agentCount := turn allDelegatedSessions size.
	toolCount := self toolCalls size.
	agentCount > 0
		ifTrue: [ labels add: agentCount asString , ' ' , ('agent' asPluralBasedOn: agentCount) ].
	toolCount > 0
		ifTrue: [ labels add: toolCount asString , ' ' , ('tool' asPluralBasedOn: toolCount) ].
	^ labels
]

{ #category : #accessing }
GtLACPAssistantMessage >> workSummaryDetails [
	| latest string owner |
	latest := self latestWorkItem.
	string := latest
			ifNil: [ '' ]
			ifNotNil: [ string := latest workSummaryText.
				owner := turn turnForWorkItem: latest.
				(owner notNil and: [ owner ~~ turn ])
					ifTrue: [ string := owner session conversationTitle , ': ' , string ].
				(string copyReplaceAll: String cr with: ' ')
					copyReplaceAll: String lf
					with: ' ' ].
	string size > 140 ifTrue: [ string := (string first: 139) , '…' ].
	(turn permissionRequests anySatisfy: [ :each | each state = #pending ])
		ifTrue: [ string := string
					ifEmpty: [ 'permission required' ]
					ifNotEmpty: [ string , ' · permission required' ] ].
	^ string
]
