namespace Orbis.UI.Components.Tables;

public sealed record OrbisColumn<TItem>(
    string Header,
    Func<TItem, object?> Value,
    string? CssClass = null);
