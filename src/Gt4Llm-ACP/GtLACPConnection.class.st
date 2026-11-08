"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPConnection,
	#superclass : #GtLACPObject,
	#instVars : [
		'transport',
		'state',
		'capabilities',
		'authenticationMethods',
		'agentInfo',
		'pendingRequests',
		'nextId',
		'sessions',
		'transcript',
		'lastError',
		'requestTimeout',
		'lock',
		'announcer',
		'pendingCommandAdvertisements',
		'notificationPublisher'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPConnection >> agentInfo [
 ^ agentInfo
]

{ #category : #accessing }
GtLACPConnection >> agentInfo: anObject [
 agentInfo := anObject
]

{ #category : #announcing }
GtLACPConnection >> announceConversationTreeChanged [
 self announcer announce: GtLACPConversationTreeChanged new
]

{ #category : #announcing }
GtLACPConnection >> announcer [
 ^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #authentication }
GtLACPConnection >> authenticate: aMethodId [
 (authenticationMethods anySatisfy: [ :each | (each at: 'id') = aMethodId ])
  ifFalse: [ self error: 'Authentication method is not advertised by the agent' ].
 ^ self request: 'authenticate' parameters: { 'methodId' -> aMethodId } asDictionary
]

{ #category : #accessing }
GtLACPConnection >> authenticationMethods [
 ^ authenticationMethods
]

{ #category : #accessing }
GtLACPConnection >> authenticationMethods: anObject [
 authenticationMethods := anObject
]

{ #category : #protocol }
GtLACPConnection >> cancelInboundRequest: anId [
	sessions
		valuesDo: [ :aSession | 
			aSession turns
				do: [ :turn | 
					turn permissionRequests , turn elicitationRequests
						do: [ :each | each requestId = anId ifTrue: [ each abandon ] ] ] ]
]

{ #category : #accessing }
GtLACPConnection >> capabilities [
 ^ capabilities
]

{ #category : #accessing }
GtLACPConnection >> capabilities: anObject [
 capabilities := anObject
]

{ #category : #accessing }
GtLACPConnection >> clientCapabilities [
	^ {'subagents' -> Dictionary new.
		'elicitation' -> {'form' -> Dictionary new} asDictionary} asDictionary
]

{ #category : #private }
GtLACPConnection >> dispatch: aDictionary [
	| method params aSession |
	method := aDictionary at: 'method'.
	params := aDictionary at: 'params' ifAbsent: [ Dictionary new ].
	method = 'session/update' ifTrue: [ ^ self receiveSessionUpdate: params ].
	method = '$/cancel_request'
		ifTrue: [ ^ self
				cancelInboundRequest: (params at: 'requestId' ifAbsent: [ params at: 'id' ifAbsent: [ nil ] ]) ].
	(aDictionary includesKey: 'id') ifFalse: [ ^ self ].
	(#('session/request_permission' 'elicitation/create' 'session/create_elicitation')
		includes: method)
		ifFalse: [ ^ self
				replyErrorTo: (aDictionary at: 'id')
				code: -32601
				message: 'Method not supported' ].
	aSession := sessions
			at: (params at: 'sessionId' ifAbsent: [ nil ])
			ifAbsent: [ nil ].
	aSession
		ifNil: [ ^ self
				replyErrorTo: (aDictionary at: 'id')
				code: -32602
				message: 'Unknown session' ].
	method = 'session/request_permission'
		ifTrue: [ ^ aSession receivePermission: params requestId: (aDictionary at: 'id') ].
	^ aSession receiveElicitation: params requestId: (aDictionary at: 'id')
]

{ #category : #lifecycle }
GtLACPConnection >> failed: aReason [
 | requests |
 lastError := aReason.
 state := #failed.
 requests := lock critical: [ | values |
  values := pendingRequests values asArray.
  pendingRequests removeAll.
  values ].
 requests do: [ :each | each fail: aReason ].
 sessions valuesDo: [ :each | each connectionClosed: aReason ]
]

{ #category : #views }
GtLACPConnection >> gtAuthenticationFor: aView [
 <gtView>
 ^ aView columnedList title: 'Authentication methods'; priority: 10;
  items: [ authenticationMethods ];
  column: 'Method' text: [ :each | each at: 'name' ifAbsent: [ each at: 'id' ] ];
  column: 'ID' text: [ :each | each at: 'id' ];
  column: 'Description' text: [ :each | each at: 'description' ifAbsent: [ '' ] ]
]

{ #category : #views }
GtLACPConnection >> gtCapabilitiesFor: aView [
 <gtView>
 ^ aView forward title: 'Capabilities'; priority: 5;
  object: [ capabilities ]; view: #gtCapabilitiesFor:
]

{ #category : #views }
GtLACPConnection >> gtConnectionFor: aView [
 <gtView>
 ^ aView columnedList title: 'Connection'; priority: 0;
  items: [ {
   'Status' -> state.
   'Agent' -> agentInfo.
   'Transport' -> transport.
   'Last failure' -> lastError } ];
  column: 'Connection' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh connection'
]

{ #category : #views }
GtLACPConnection >> gtConversationTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Conversation tree';
		priority: 4;
		object: [ GtLACPSessionGroup withAll: self rootSessions ];
		view: #gtConversationTreeFor:
]

{ #category : #views }
GtLACPConnection >> gtPendingRequestsFor: aView [
 <gtView>
 ^ aView list title: 'Pending requests'; priority: 20; items: [ pendingRequests values asArray ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh pending requests'
]

{ #category : #views }
GtLACPConnection >> gtSessionsFor: aView [
 <gtView>
 ^ aView list title: 'Sessions'; priority: 20; items: [ sessions values asArray ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh sessions'
]

{ #category : #actions }
GtLACPConnection >> gtStopFor: anAction [
 <gtAction>
 ^ anAction button label: 'Stop'; priority: 50; action: [ self stop ]
]

{ #category : #views }
GtLACPConnection >> gtTranscriptFor: aView [
	<gtView>
	^ aView forward
		title: 'History';
		priority: 1;
		object: [ transcript ];
		view: #gtMessagesFor:
]

{ #category : #accessing }
GtLACPConnection >> initialize [
 super initialize.
 state := #stopped.
 capabilities := GtLACPCapabilities new.
 authenticationMethods := #().
 agentInfo := Dictionary new.
 pendingRequests := Dictionary new.
 sessions := Dictionary new.
 nextId := 0.
 transcript := GtLACPProtocolTranscript new.
 requestTimeout := 30.
 lock := Mutex new
]

{ #category : #testing }
GtLACPConnection >> isFailed [
	^ state = #failed
]

{ #category : #testing }
GtLACPConnection >> isInitializing [
	^ state = #initializing
]

{ #category : #testing }
GtLACPConnection >> isReady [
	^ state = #ready
]

{ #category : #testing }
GtLACPConnection >> isStopped [
	^ state = #stopped
]

{ #category : #accessing }
GtLACPConnection >> lastError [
 ^ lastError
]

{ #category : #accessing }
GtLACPConnection >> lastError: anObject [
 lastError := anObject
]

{ #category : #accessing }
GtLACPConnection >> lock [
 ^ lock
]

{ #category : #accessing }
GtLACPConnection >> lock: anObject [
 lock := anObject
]

{ #category : #requests }
GtLACPConnection >> newRequest: aMethod parameters: aDictionary [
	| aRequest |
	(self isInitializing or: [ self isReady ])
		ifFalse: [ self error: 'Connection is not running' ].
	lock
		critical: [ nextId := nextId + 1.
			aRequest := GtLACPRequest new
					id: nextId;
					method: aMethod;
					parameters: aDictionary;
					yourself.
			pendingRequests at: nextId put: aRequest ].
	^ aRequest
]

{ #category : #accessing }
GtLACPConnection >> nextId [
 ^ nextId
]

{ #category : #accessing }
GtLACPConnection >> nextId: anObject [
 nextId := anObject
]

{ #category : #accessing }
GtLACPConnection >> notificationPublisher: aBlock [
	"Allow isolated notification collections in examples and embedding clients."

	notificationPublisher := aBlock
]

{ #category : #requests }
GtLACPConnection >> notify: aMethod parameters: aDictionary [
 self send: { 'jsonrpc' -> '2.0'. 'method' -> aMethod. 'params' -> aDictionary } asDictionary
]

{ #category : #accessing }
GtLACPConnection >> pendingCommandAdvertisements [
	^ pendingCommandAdvertisements
		ifNil: [ pendingCommandAdvertisements := Dictionary new ]
]

{ #category : #accessing }
GtLACPConnection >> pendingRequests [
 ^ pendingRequests
]

{ #category : #accessing }
GtLACPConnection >> pendingRequests: anObject [
 pendingRequests := anObject
]

{ #category : #notifications }
GtLACPConnection >> publishInputNotification: aNotification [
	notificationPublisher
		ifNotNil: [ ^ notificationPublisher value: aNotification ].
	aNotification registerNotifications
]

{ #category : #dispatching }
GtLACPConnection >> receive: aDictionary [
 | aRequest |
 transcript record: aDictionary direction: #incoming.
 (aDictionary at: 'jsonrpc' ifAbsent: [ '' ]) = '2.0' ifFalse: [ self error: 'Invalid JSON-RPC version' ].
 (aDictionary includesKey: 'method') ifTrue: [ ^ self dispatch: aDictionary ].
 aRequest := lock critical: [ pendingRequests removeKey: (aDictionary at: 'id') ifAbsent: [ nil ] ].
 aRequest ifNil: [ ^ self ].
 (aDictionary includesKey: 'error')
  ifTrue: [ aRequest fail: (aDictionary at: 'error') ]
  ifFalse: [ aRequest complete: (aDictionary at: 'result') ]
]

{ #category : #receiving }
GtLACPConnection >> receiveSessionUpdate: params [
	| session update sessionId |
	sessionId := params at: 'sessionId'.
	update := params at: 'update'.
	session := lock
			critical: [ | known |
				known := sessions at: sessionId ifAbsent: [ nil ].
				(known isNil
					and: [ (update at: 'sessionUpdate') = 'available_commands_update' ])
					ifTrue: [ self pendingCommandAdvertisements at: sessionId put: update deepCopy ].
				known ].
	session ifNotNil: [ session receiveUpdate: update ]
]

{ #category : #sessions }
GtLACPConnection >> registerSession: aSession [
	| sessionId |
	sessionId := aSession remoteSessionId.
	[ | snapshot |
	snapshot := lock
			critical: [ self pendingCommandAdvertisements
					removeKey: sessionId
					ifAbsent: [ sessions at: sessionId put: aSession.
						^ aSession ] ].
	aSession receiveUpdate: snapshot ] repeat
]

{ #category : #requests }
GtLACPConnection >> replyErrorTo: anId code: aCode message: aMessage [
 self send: { 'jsonrpc' -> '2.0'. 'id' -> anId.
 'error' -> { 'code' -> aCode. 'message' -> aMessage } asDictionary } asDictionary
]

{ #category : #requests }
GtLACPConnection >> replyTo: anId result: aDictionary [
 self send: { 'jsonrpc' -> '2.0'. 'id' -> anId. 'result' -> aDictionary } asDictionary
]

{ #category : #requests }
GtLACPConnection >> request: aMethod parameters: aDictionary [
	| aRequest |
	aRequest := self newRequest: aMethod parameters: aDictionary.
	self sendRequest: aRequest.
	^ [ [ aRequest waitForSeconds: requestTimeout ]
		on: Error
		do: [ :ex | 
			aRequest fail: ex messageText.
			ex pass ] ]
		ensure: [ lock critical: [ pendingRequests removeKey: aRequest id ifAbsent: [  ] ] ]
]

{ #category : #accessing }
GtLACPConnection >> requestTimeout [
 ^ requestTimeout
]

{ #category : #accessing }
GtLACPConnection >> requestTimeout: anObject [
 requestTimeout := anObject
]

{ #category : #accessing }
GtLACPConnection >> rootSessions [
 ^ sessions values select: [ :session | session isSubagent not ]
]

{ #category : #requests }
GtLACPConnection >> send: aDictionary [
 transcript record: aDictionary direction: #outgoing.
 transport send: aDictionary
]

{ #category : #requests }
GtLACPConnection >> sendRequest: aRequest [
 [ self send: aRequest asDictionary ]
 on: Error do: [ :ex |
  lock critical: [ pendingRequests removeKey: aRequest id ifAbsent: [ ] ].
  aRequest fail: ex messageText.
  ex pass ].
 ^ aRequest
]

{ #category : #accessing }
GtLACPConnection >> sessions [
 ^ sessions
]

{ #category : #accessing }
GtLACPConnection >> sessions: anObject [
 sessions := anObject
]

{ #category : #lifecycle }
GtLACPConnection >> start [
	| result |
	self isStopped ifFalse: [ self error: 'Connection has already been started' ].
	state := #initializing.
	transport connection: self.
	[ transport start.
	result := self
			request: 'initialize'
			parameters: {'protocolVersion' -> 1.
					'clientCapabilities' -> self clientCapabilities.
					'clientInfo'
						-> {'name' -> 'glamorous-toolkit'.
								'version' -> '0.1.0'} asDictionary} asDictionary.
	(result at: 'protocolVersion') = 1
		ifFalse: [ self error: 'Unsupported ACP protocol version' ].
	capabilities
		data: (result at: 'agentCapabilities' ifAbsent: [ Dictionary new ]).
	authenticationMethods := result at: 'authMethods' ifAbsent: [ #() ].
	agentInfo := result at: 'agentInfo' ifAbsent: [ Dictionary new ].
	state := #ready ]
		on: Error
		do: [ :ex | 
			self failed: ex messageText.
			transport close.
			ex pass ]
]

{ #category : #accessing }
GtLACPConnection >> state [
 ^ state
]

{ #category : #accessing }
GtLACPConnection >> state: anObject [
 state := anObject
]

{ #category : #lifecycle }
GtLACPConnection >> stop [
	self isStopped ifTrue: [ ^ self ].
	self failed: 'Connection stopped'.
	transport close.
	state := #stopped
]

{ #category : #accessing }
GtLACPConnection >> transcript [
 ^ transcript
]

{ #category : #accessing }
GtLACPConnection >> transcript: anObject [
 transcript := anObject
]

{ #category : #accessing }
GtLACPConnection >> transport [
 ^ transport
]

{ #category : #accessing }
GtLACPConnection >> transport: anObject [
 transport := anObject
]
