import AppKit

final class TrayMenu: NSMenu, NSMenuDelegate {
    private let onSelect: (Int) -> Void
    private let onClose: (() -> Void)?
    private var contents: [TrayMenuItemView.Content?] = []

    init(items: [[String: Any]], onSelect: @escaping (Int) -> Void, onClose: (() -> Void)? = nil) {
        self.onSelect = onSelect
        self.onClose = onClose
        super.init(title: "")
        autoenablesItems = false
        delegate = self
        for entry in items {
            let item = makeItem(entry)
            addItem(item)
            let type = entry["type"] as? String ?? ""
            contents.append(
                item.isSeparatorItem || type == "metrics" || type == "segmented"
                    ? nil
                    : TrayMenu.content(entry, item)
            )
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func detail(_ entry: [String: Any]) -> String? {
        guard let detail = entry["detail"] as? String, !detail.isEmpty else {
            return nil
        }
        return detail
    }

    private func makeItem(_ entry: [String: Any]) -> NSMenuItem {
        let type = entry["type"] as? String ?? ""
        if type == "separator" {
            return NSMenuItem.separator()
        }

        let item = NSMenuItem()
        item.title = entry["label"] as? String ?? ""
        item.tag = entry["id"] as? Int ?? 0
        item.isEnabled = entry["enabled"] as? Bool ?? true
        item.state = type == "checkbox" && entry["checked"] as? Bool == true ? .on : .off

        if type == "metrics" {
            let metrics = entry["metrics"] as? [[String: String]] ?? []
            item.view = TrayMetricsView(metrics: metrics)
        } else if type == "segmented" {
            let options = entry["options"] as? [[String: Any]] ?? []
            let labels = options.map { $0["label"] as? String ?? "" }
            let control = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: self, action: #selector(didSelectSegment(_:)))
            control.segmentStyle = .rounded
            control.segmentDistribution = .fillEqually
            for (index, option) in options.enumerated() {
                control.setEnabled(option["enabled"] as? Bool ?? true, forSegment: index)
                if option["selected"] as? Bool == true { control.selectedSegment = index }
            }
            control.identifier = NSUserInterfaceItemIdentifier(
                rawValue: options.map { String($0["id"] as? Int ?? 0) }.joined(separator: ",")
            )
            item.view = TraySegmentedView(title: entry["label"] as? String ?? "", control: control)
        } else if type == "submenu" {
            let children = entry["items"] as? [[String: Any]] ?? []
            setSubmenu(TrayMenu(items: children, onSelect: onSelect), for: item)
        } else {
            item.target = self
            item.action = #selector(didSelectItem(_:))
        }
        return item
    }

    private static func content(_ entry: [String: Any], _ item: NSMenuItem) -> TrayMenuItemView.Content {
        TrayMenuItemView.Content(
            label: item.title,
            detail: detail(entry),
            checked: item.state == .on,
            enabled: item.isEnabled,
            hasSubmenu: item.hasSubmenu
        )
    }

    // A delay test rebuilds the menu per result; measuring every row then costs ~20x.
    func menuNeedsUpdate(_ menu: NSMenu) {
        guard !contents.isEmpty else {
            return
        }
        for (item, content) in zip(items, contents) {
            if let content = content {
                item.view = TrayMenuItemView(content: content)
            }
        }
        contents = []
    }

    // AppKit does not redraw an item's view when its highlight changes.
    func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
        highlightedItem?.view?.needsDisplay = true
        item?.view?.needsDisplay = true
    }

    func menuDidClose(_ menu: NSMenu) {
        onClose?()
    }

    @objc private func didSelectItem(_ sender: NSMenuItem) {
        onSelect(sender.tag)
    }

    @objc private func didSelectSegment(_ sender: NSSegmentedControl) {
        let ids = sender.identifier?.rawValue.split(separator: ",").compactMap { Int($0) } ?? []
        guard ids.indices.contains(sender.selectedSegment) else { return }
        cancelTracking()
        onSelect(ids[sender.selectedSegment])
    }
}

private final class TrayMetricsView: NSView {
    private let metrics: [[String: String]]
    private let font = NSFont.menuFont(ofSize: 0)
    private var valueFont: NSFont { .monospacedDigitSystemFont(ofSize: font.pointSize, weight: .medium) }

    init(metrics: [[String: String]]) {
        self.metrics = metrics
        super.init(frame: NSRect(x: 0, y: 0, width: 250, height: 44))
        autoresizingMask = [.width]
        setAccessibilityElement(true)
        setAccessibilityRole(.staticText)
        setAccessibilityLabel(metrics.map { "\($0["label"] ?? ""), \($0["value"] ?? "")" }.joined(separator: ", "))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ dirtyRect: NSRect) {
        guard !metrics.isEmpty else { return }
        let columnWidth = bounds.width / CGFloat(metrics.count)
        for (index, metric) in metrics.enumerated() {
            let x = CGFloat(index) * columnWidth + 12
            let label = metric["label"] ?? ""
            let value = metric["value"] ?? ""
            (label as NSString).draw(at: NSPoint(x: x, y: 25), withAttributes: [.font: font, .foregroundColor: NSColor.secondaryLabelColor])
            (value as NSString).draw(at: NSPoint(x: x, y: 8), withAttributes: [.font: valueFont, .foregroundColor: NSColor.labelColor])
        }
    }
}

private final class TraySegmentedView: NSView {
    init(title: String, control: NSSegmentedControl) {
        super.init(frame: NSRect(x: 0, y: 0, width: 250, height: 50))
        autoresizingMask = [.width]
        let heading = NSTextField(labelWithString: title)
        heading.font = .menuFont(ofSize: 0)
        heading.textColor = .secondaryLabelColor
        heading.frame = NSRect(x: 12, y: 29, width: 226, height: 15)
        heading.autoresizingMask = [.width]
        control.frame = NSRect(x: 12, y: 3, width: 226, height: 22)
        control.autoresizingMask = [.width]
        control.setAccessibilityLabel(title)
        addSubview(heading)
        addSubview(control)
        setAccessibilityElement(true)
        setAccessibilityRole(.group)
        setAccessibilityLabel(title)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
