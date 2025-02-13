Class {
	#name : #GtLlmWardleyMapTutor,
	#superclass : #GtLlmTutor,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> connectionAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Add new connected nodes';
		priority: 2;
		description: 'Adds new nodes that are connected to an already existing node. It MUST consider the context of the map topic. It MUST return the entirety of the state.';
		format: 'Add new connected nodes to `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Compute`'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]
component Platform [0.73, 0.71] label [-26, 29]
component Cloud [0.9, 0.81] label [-26, 29]

Compute->Platform
Compute->Cloud'.
							'Text' -> nil.
							'Rename' -> nil} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Regulator`'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
component Audit [0.8, 0.8] label [-26, 29]

Regulator->Audit
'.
							'Text' -> nil.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> createAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		priority: 1;
		description: 'Creates a set of at least 20 nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended.';
		format: 'Create a set of nodes on {1}'
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> createChatOn: aGtWardleyMapModel [
	| chat |
	chat := self createChat.
	chat onInstance: (self valueHolderFor: aGtWardleyMapModel).
	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> defaultDescription [
	^ 'You are an assistant that is used to interactively work on Wardley Maps. You trigger certain actions to generate a desired result.'
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIAssistantProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAIWardleyMapMessage;
		userMessageClass: GtOpenAIWardleyMapMessage ]
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain a node';
		priority: 3;
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain `Compute`'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Explain a node'.
							'Text'
								-> 'In the context of this Wardley Map on Cloud Computing, the node `Compute` refers to the computing resources and capabilities provided as part of cloud services. This encompasses the virtualized processing power (CPUs, GPUs) that can be scaled up or down on demand to meet the needs of applications or services running in the cloud. The `Compute` node is fundamental to cloud computing, as it allows for flexible, efficient, and scalable computing solutions that can be tailored to the specific requirements of businesses and developers.

The presence of `Compute` in a cloud computing map highlights its role as a core component of the cloud value chain, directly supporting various higher-level services and applications that depend on reliable and scalable computing resources. It could be connected to nodes representing services that leverage these computing resources, such as web hosting, data analytics platforms, or any software-as-a-service (SaaS) applications, indicating a dependency relationship where these services rely on the underlying compute capabilities to function effectively.

In summary, `Compute` signifies the provisioning of raw processing power in the cloud, which is pivotal to the delivery of a wide range of cloud-based services and applications, illustrating the utility and flexibility offered by cloud computing paradigms.'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]'.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Compute`'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename' -> nil.
							'Text' -> nil.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'.
							'Rename' -> '{''Compute'': [''Computational resources'', ''Resources'']}'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Furnace`'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename'
								-> '{''Furnace'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'.
							'Text' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> renameFormatComponent [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Rename';
		priority: 2;
		format: 'Text';
		example: '```
{''Node name'': [''Proposal A'', ''Proposal B'']}
```'
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the current state';
		priority: 5;
		description: 'Reviews and criticizes the current state of the map.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Review the current state'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Text'
								-> 'The map is incomplete. Currently, only one node is defined. A complete map should have multiple nodes and connections. The current node `Compute` is correct, but misplaced.'.
							'Action' -> 'Review the current state'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'.
							'Rename' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> valueHolderFor: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Wardley Map';
		content: anObject;
		serializer: #asWardleyMapScript;
		updater: [ :aModel :aText | 
			(GtWardleyMapDiffer
				diffFrom: aModel
				to: (GtWardleyMapParser parse: aText) asWardleyMapModel) merge ]
]

{ #category : #'as yet unclassified' }
GtLlmWardleyMapTutor >> wardleyMapFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Wardley Map';
		priority: 2;
		format: 'Wardley Map language';
		example: '```
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Hello [0.80, 0.20] label [-14, 29]

component Goodbye [0.40, 0.60] label [-22, 29]

component Hello again! [0.60, 0.80] label [-42, 29]


Hello->Goodbye
Goodbye->Hello again!
```'
]
