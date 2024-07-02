Class {
	#name : #GtOpenAIWardleyMapActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIWardleyMapActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> connectionAction [
	^ GtLlmTutorAction new
		name: 'Add a new connected node';
		description: 'Adds a new node that is connected to an already existing node. It MUST consider the context of the map topic. It MUST return the entirety of the state.';
		format: 'Add a new connected node to `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Add a new connected node to `Compute`';
					input: '```topic
Cloud computing
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

```';
					output: '```action
Add a new connected node
```
```topic
Cloud computing
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

component Platform [0.73, 0.71] label [-26, 29]


Compute->Platform
```'.
				GtLlmTutorActionExample new
					instruction: 'Add a new connected node to `Regulator`';
					input: '```action
Add a new connected node
```
```topic
Regulation
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
```';
					output: '```action
Add a new connected node
```
```topic
Regulation
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]

component Audit [0.8, 0.8] label [-26, 29]


Compute->Platform
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> explanationAction [
	^ GtLlmTutorAction new
		name: 'Explain a node';
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Explain `Compute`';
					input: '```topic
Cloud computing
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]
```';
					output: '```action
Explain a node
```
```explanation
In the context of this Wardley Map on Cloud Computing, the node `Compute` refers to the computing resources and capabilities provided as part of cloud services. This encompasses the virtualized processing power (CPUs, GPUs) that can be scaled up or down on demand to meet the needs of applications or services running in the cloud. The `Compute` node is fundamental to cloud computing, as it allows for flexible, efficient, and scalable computing solutions that can be tailored to the specific requirements of businesses and developers.

The presence of `Compute` in a cloud computing map highlights its role as a core component of the cloud value chain, directly supporting various higher-level services and applications that depend on reliable and scalable computing resources. It could be connected to nodes representing services that leverage these computing resources, such as web hosting, data analytics platforms, or any software-as-a-service (SaaS) applications, indicating a dependency relationship where these services rely on the underlying compute capabilities to function effectively.

In summary, `Compute` signifies the provisioning of raw processing power in the cloud, which is pivotal to the delivery of a wide range of cloud-based services and applications, illustrating the utility and flexibility offered by cloud computing paradigms.
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialAction [
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		description: 'Creates a set of nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended.';
		format: 'Create a set of nodes on {1}';
		examples: {GtLlmTutorActionExample new
					instruction: 'Create a set of nodes on Key components for a drone delivery service';
					input: '```topic
```
```wardley-map
```';
					output: '```action
Create a set of nodes
```
```topic
Key components for a drone delivery service
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Customer need [0.90, 0.95] label [4, -4]

component Drone delivery platform [0.70, 0.80] label [-12, -3]
component Drones [0.60, 0.60] label [-12, 3]
component Maintenance service for drones [0.50, 0.50] label [-22, 35]
component Regulatory compliance [0.30, 0.80] label [-22, 25]
component Weather monitoring system [0.40, 0.50] label [2, 15]
component Navigation and GPS [0.30, 0.60] label [2, 25]
component Air traffic control system [0.20, 0.70] label [-12, 15]
component Automated package handling system [0.50, 0.60] label [-2, -15]
component Communication system [0.40, 0.60] label [12, -15]
component Computing resources [0.20, 0.30] label [-42, -5]
component Data storage [0.20, 0.40] label [-52, -5]
component Cybersecurity measures [0.10, 0.60] label [-52, 15]
component Software development [0.30, 0.20] label [-52, 25]
component Power supply and charging stations [0.20, 0.50] label [22, -5]

Customer need->Drone delivery platform
Drone delivery platform->Drones
Drones->Maintenance service for drones
Drone delivery platform->Regulatory compliance
Drone delivery platform->Weather monitoring system
Drones->Navigation and GPS
Drones->Air traffic control system
Drone delivery platform->Automated package handling system
Drone delivery platform->Communication system
Drone delivery platform->Computing resources
Drones->Power supply and charging stations
Drone delivery platform->Data storage
Drone delivery platform->Software development
Drone delivery platform->Cybersecurity measures
```'.
				GtLlmTutorActionExample new
					instruction: 'Create a set of nodes on Moldable development';
					input: '```topic
```
```wardley-map
```';
					output: '```action
Create a set of nodes
```
```topic
Moldable development
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component User Feedback [0.4, 0.85] label [-22, 29]
component Programming Languages [0.8, 0.3] label [-42, 29]
component Problem Domain [0.2, 0.9] label [14, 29]
component Customization Frameworks [0.5, 0.7] label [-62, 29]
component Frameworks and Libraries [0.75, 0.2] label [-82, 29]
component Moldable Tools [0.4, 0.8] label [-102, 29]
component Developer Skills [0.3, 0.7] label [34, 29]
component Development Practices [0.1, 0.1] label [54, 29]

User Feedback->Moldable Tools
User Feedback->Customization Frameworks
Developer Skills->Moldable Tools
Developer Skills->Programming Languages
Developer Skills->Frameworks and Libraries
Moldable Tools->Problem Domain
Customization Frameworks->Problem Domain
Development Practices->Moldable Tools
Development Practices->Customization Frameworks
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialize [
	super initialize.

	self initializeFormat.
	self initializeActions.
	self initializePipeline
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializeActions [
	actions addAll: {
		self initialAction.
		self connectionAction.
		self explanationAction.
		self renameAction.
		self reviewAction
	}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializeFormat [
	format := GtLlmTutorFormat new
			name: 'Wardley Map';
			addComponent: (GtLlmTutorComponent new
					name: 'Topic';
					format: 'Text';
					tag: 'topic';
					example: '```topic
Cloud computing in regulated areas
```');
			addComponent: (GtLlmTutorComponent new
					name: 'Wardley Map';
					format: 'Wardley Map script language';
					tag: 'wardley-map';
					example: '```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Hello [0.80, 0.20] label [-14, 29]

component Goodbye [0.40, 0.60] label [-22, 29]

component Hello again! [0.60, 0.80] label [-42, 29]


Hello->Goodbye
Goodbye->Hello again!
```');
			addComponent: (GtLlmTutorComponent new
					name: 'Explanation';
					format: 'Text';
					tag: 'explanation';
					example: '```explanation
Human readable text goes here
```')
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmActionWardleyMapCreator new;
				isImmutableInstance: true;
				checker: (GtLlmAlternativeCodeStep new
						addAlternative: GtLlmWardleyMapTopicStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'topic' ];
						addAlternative: GtLlmWardleyMapMapStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'wardley-map' ];
						addAlternative: GtLlmWardleyMapRenameStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'rename' ];
						addAlternative: GtLlmWardleyMapExplanationStep new
							matching: [ :aContext | aContext lastResult isForLanguage: 'explanation' ]) ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameAction [
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {GtLlmTutorActionExample new
					instruction: 'Propose renames for node `Compute`';
					input: '```topic
Cloud computing
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]
```';
					output: '```action
Propose renames for node
```
```rename
{''Compute'': [''Computational resources'', ''Resources'']}
```'.
				GtLlmTutorActionExample new
					instruction: 'Propose renames for node `Furnace`';
					input: '```topic
Appliances
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furance [0.9, 0.9] label [-9, 9]
```';
					output: '```action
Propose renames for node
```
```rename
{''Furnace'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}
```'}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> reviewAction [
	^ GtLlmTutorAction new
		name: 'Review the current state';
		description: 'Reviews and criticizes the current state of the map.';
		examples: {GtLlmTutorActionExample new
					instruction: 'Review the current state';
					input: '```topic
Cloud computing
```
```wardley-map
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

```';
					output: '```explanation
The map is incomplete. Currently, only one node is defined. A complete map should have multiple nodes and connections. The current node `Compute` is correct, but misplaced.
```'}
]
