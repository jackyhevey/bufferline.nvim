---@meta _

---@class bufferline.DebugOpts
---@field logging boolean

---@class bufferline.GroupOptions
---@field toggle_hidden_on_enter boolean re-open hidden groups on bufenter

---@class bufferline.GroupOpts
---@field options bufferline.GroupOptions
---@field items bufferline.Group[]

---@class bufferline.Indicator
---@field style "underline" | "icon" | "none"
---@field icon string?

---@alias bufferline.Mode 'tabs' | 'buffers'

---@alias bufferline.DiagnosticIndicator fun(count: number, level: number, errors: table<string, any>, ctx: table<string, any>): string

---@alias bufferline.HoverOptions {reveal: string[], delay: integer, enabled: boolean}
---@alias bufferline.IconFetcherOpts {directory: boolean, path: string, extension: string, filetype: string?}

---@class bufferline.Options
---@field public mode bufferline.Mode
---@field public style_preset bufferline.StylePreset | bufferline.StylePreset[]
---@field public view string
---@field public debug bufferline.DebugOpts
---@field public numbers string | fun(ordinal: number, id: number, lower: number_helper, raise: number_helper): string
---@field public buffer_close_icon string
---@field public modified_icon string
---@field public close_icon string
---@field public close_command string | function
---@field public custom_filter fun(buf: number, bufnums: number[]): boolean
---@field public left_mouse_command string | function
---@field public right_mouse_command string | function
---@field public middle_mouse_command (string | function)?
---@field public indicator bufferline.Indicator
---@field public left_trunc_marker string
---@field public right_trunc_marker string
---@field public separator_style string | {[1]: string, [2]: string}
---@field public name_formatter (fun(path: string):string)?
---@field public tab_size number
---@field public truncate_names boolean
---@field public max_name_length number
---@field public color_icons boolean
---@field public show_buffer_icons boolean
---@field public show_buffer_close_icons boolean
---@field public show_buffer_default_icon boolean
---@field public get_element_icon fun(opts: bufferline.IconFetcherOpts): string?, string?
---@field public show_close_icon boolean
---@field public show_tab_indicators boolean
---@field public show_duplicate_prefix boolean
---@field public enforce_regular_tabs boolean
---@field public always_show_bufferline boolean
---@field public persist_buffer_sort boolean
---@field public max_prefix_length number
---@field public sort_by string
---@field public diagnostics boolean | 'nvim_lsp' | 'coc'
---@field public diagnostics_indicator bufferline.DiagnosticIndicator
---@field public diagnostics_update_in_insert boolean
---@field public offsets table[]
---@field public groups bufferline.GroupOpts
---@field public themable boolean
---@field public hover bufferline.HoverOptions

---@class bufferline.HLGroup
---@field fg string
---@field bg string
---@field sp string
---@field special string
---@field bold boolean
---@field italic boolean
---@field underline boolean
---@field undercurl boolean
---@field hl_group string
---@field hl_name string

---@alias bufferline.Highlights table<string, bufferline.HLGroup>

---@class bufferline.UserConfig
---@field public options bufferline.Options
---@field public highlights bufferline.Highlights | fun(BufferlineHighlights): bufferline.Highlights

---@class bufferline.Config
---@field public options bufferline.Options
---@field public highlights bufferline.Highlights
---@field user bufferline.UserConfig original copy of user preferences
---@field merge fun(self: bufferline.Config, defaults: bufferline.Config): bufferline.Config
---@field validate fun(self: bufferline.Config, defaults: bufferline.Config, resolved: bufferline.Highlights): nil
---@field resolve fun(self: bufferline.Config, defaults: bufferline.Config): bufferline.Config
---@field is_tabline fun(self: bufferline.Config):boolean

--- @alias bufferline.Visibility 1 | 2 | 3
--- @alias bufferline.Duplicate "path" | "element" | nil

---@class bufferline.Component
---@field name string?
---@field id integer
---@field path string?
---@field length integer
---@field component fun(BufferlineState): bufferline.Segment[]
---@field hidden boolean
---@field focusable boolean
---@field type 'group_end' | 'group_start' | 'buffer' | 'tabpage'
---@field __ancestor fun(self: bufferline.Component, depth: integer, formatter: (fun(string, integer): string)?): string

---@class bufferline.Tab
---@field public id integer
---@field public buf integer
---@field public icon string
---@field public name string
---@field public group string
---@field public letter string
---@field public modified boolean
---@field public modifiable boolean
---@field public duplicated bufferline.Duplicate
---@field public extension string the file extension
---@field public path string the full path to the file
---@field __ancestor fun(self: bufferline.Component, depth: integer, formatter: (fun(string, integer): string)?): string

-- A single buffer class
-- this extends the [Component] class
---@class bufferline.Buffer
---@field public extension string the file extension
---@field public path string the full path to the file
---@field public name_formatter function? dictates how the name should be shown
---@field public id integer the buffer number
---@field public name string the visible name for the file
---@field public filename string
---@field public icon string the icon
---@field public icon_highlight string?
---@field public diagnostics table
---@field public modified boolean
---@field public modifiable boolean
---@field public buftype string
---@field public letter string?
---@field public ordinal integer
---@field public duplicated bufferline.Duplicate
---@field public prefix_count integer
---@field public component BufferComponent
---@field public group string?
---@field public group_fn string
---@field public length integer the length of the buffer component
---@field public visibility fun(self: bufferline.Component): integer
---@field public current fun(self: bufferline.Component): boolean
---@field public visible fun(self: bufferline.Component): boolean
---@field public ancestor fun(self: bufferline.Buffer, depth: integer, formatter: fun(string): string, depth: integer): string
---@field private __ancestor fun(self: bufferline.Component, depth: integer, formatter: (fun(string, integer): string)?): string
---@field public find_index fun(Buffer, BufferlineState): integer?
---@field public is_new fun(Buffer, BufferlineState): boolean
---@field public is_existing fun(Buffer, BufferlineState): boolean

---@alias bufferline.ComponentsByGroup (bufferline.Group | bufferline.Component[])[]

--- @class bufferline.GroupState
--- @field manual_groupings table<number, string>
--- @field user_groups table<string, bufferline.Group>
--- @field components_by_group bufferline.ComponentsByGroup

--- @class bufferline.Separators
--- @field sep_start bufferline.Segment[]
--- @field sep_end bufferline.Segment[]

---@alias GroupSeparator fun(group:bufferline.Group, hls: bufferline.HLGroup, count_item: string?): bufferline.Separators
---@alias GroupSeparators table<string, GroupSeparator>

---@class bufferline.Group
---@field public id string used for identifying the group in the tabline
---@field public name string 'formatted name of the group'
---@field public display_name string original name including special characters
---@field public matcher fun(b: bufferline.Buffer): boolean?
---@field public separator GroupSeparators
---@field public priority number
---@field public highlight table<string, string>
---@field public icon string
---@field public hidden boolean
---@field public with fun(Group, Group): bufferline.Group
---@field auto_close boolean when leaving the group automatically close it
