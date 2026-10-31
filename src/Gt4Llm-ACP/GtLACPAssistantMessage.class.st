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
 | items index |
 items := turn activity copy.
 index := items size.
 [ index > 0 and: [
  ((items at: index) isKindOf: GtLACPConversationMessage) and: [
   (items at: index) role = #agent ] ] ] whileTrue: [ index := index - 1 ].
 ^ items copyFrom: index + 1 to: items size
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
  stencil: [
   BrEditor new
    id: #'acp-final-text';
    aptitude: BrGlamorousRegularEditorAptitude;
    beReadOnlyWithSelection;
    hMatchParent;
    vFitContentLimited;
    styler: (GtLMessageStyler new objectRegistry: aPhlowContext objectRegistry; yourself);
    text: self text;
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

{ #category : #testing }
GtLACPAssistantMessage >> hasCompletedReply [
 ^ (#(completed replayed idle) includes: turn state) and: [ self finalMessages notEmpty ]
]

{ #category : #testing }
GtLACPAssistantMessage >> hasWork [
 ^ self localActivityItems notEmpty or: [ self delegatedMessages notEmpty ]
]

{ #category : #accessing }
GtLACPAssistantMessage >> localActivityItems [
 | items |
 items := turn activity copy.
 ^ items first: items size - self finalMessages size
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
 | tools tool summary otherCount |
 tools := self toolCalls.
 tools isEmpty ifTrue: [
  | text |
  (self localActivityItems isEmpty and: [ self delegatedMessages notEmpty ])
   ifTrue: [ ^ self delegatedMessages last chatLabel ].
  text := self activityItems ifEmpty: [ '' ] ifNotEmpty: [ self activityItems last text ].
  text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
  ^ text size > 140 ifTrue: [ (text first: 140), '…' ] ifFalse: [ text ] ].
 tool := tools reversed detect: [ :each | #('pending' 'in_progress' 'running') includes: each status ]
  ifNone: [ tools last ].
 summary := tool shortDescription.
 otherCount := tools size - 1.
 otherCount > 0 ifTrue: [
  summary := summary, ' + ', otherCount asString, (otherCount = 1 ifTrue: [ ' other tool' ] ifFalse: [ ' other tools' ]) ].
 (turn permissionRequests anySatisfy: [ :each | each state = #pending ])
  ifTrue: [ summary := summary, ' · permission required' ].
 ^ summary
]
